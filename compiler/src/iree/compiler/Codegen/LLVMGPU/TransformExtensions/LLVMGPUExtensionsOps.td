// Copyright 2022 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_COMPILER_CODEGEN_LLVMGPU_TRANSFORMEXTENSIONS_LLVMGPUEXTENSIONS
#define IREE_COMPILER_CODEGEN_LLVMGPU_TRANSFORMEXTENSIONS_LLVMGPUEXTENSIONS

include "mlir/Dialect/PDL/IR/PDLTypes.td"
include "mlir/Dialect/Transform/IR/TransformDialect.td"
include "mlir/Dialect/Transform/IR/TransformInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/OpBase.td"

def MapNestedForeachThreadToGpuThreads : 
  Op<Transform_Dialect, "iree.map_nested_foreach_thread_to_gpu_threads",
    [FunctionalStyleTransformOpTrait, 
     MemoryEffectsOpInterface,
     TransformEachOpTrait,
     TransformOpInterface]> {
  let description = [{
    Target the whole hal.executable_variant op and rewrite all scf.foreach_thread
    to distributed gpu.thread_id and translation_info attribute.

    The mapping of threads to gpu.thread_id is currently one-to-one and in order.
    Only **bufferized** scf.foreach_thread are currently supported.
    Only scf.foreach_thread distributed to **at most 3 dimensions** are currently
    supported.

    Multiple scf.foreach_thread are supported per function in which case, the
    max of all the threads is computed and taken for the global gpu.thread_id.
    If necessary, scf.foreach_thread that do not use the whole thread range 
    result in predicated computations.
   
    Barriers are inserted after each scf.foreach_thread op for now.

    Return modes:
    =============
    This operation ignores non-Func ops and drops them in the return.

    If any scf.foreach_thread with tensors is found, the transform definitely 
    fails.    

    If all the scf.foreach_thread operations contained within the FuncOp 
    referred to by the `target` PDLOperation lower to GPU properly, the 
    transform succeeds. Otherwise the transform definitely fails.
    
    The returned handle points to the same FuncOp operand, consuming it and
    producing a new SSA value to satisfy chaining and linearity of the IR 
    properties.

    Example:
    ========

    ```
    hal.executable {
      hal.executable.variant {
        hal.executable.export {
          func @foo() {
            scf.foreach_thread (%i, %j) in (7, 9) {
              ... // body 1
            }
            scf.foreach_thread (%i) in (12) {
              ... // body 2
            }
          }
    ```

    is translated to:

    ```
    hal.executable {
      hal.executable.variant {
        hal.executable.export ... workgroup_size = [12 : index, 9 : index, 1 : index] {
          func @foo() {
            if (threadIdx.x < 7) {
              ... // body 1
            }
            if (threadIdx.y < 1) {
              ... // body 2
            }
          }
    ```
  }];

  let arguments = (ins PDL_Operation:$target,
                   DefaultValuedAttr<I64ArrayAttr, "{}">:$workgroup_size);
  let results = (outs PDL_Operation:$result);

  let assemblyFormat = "$target attr-dict";
  let cppNamespace = "mlir::iree_compiler::IREE::transform_dialect";

  let extraClassDeclaration = [{
    ::mlir::DiagnosedSilenceableFailure applyToOne(
        ::mlir::func::FuncOp target,
        ::llvm::SmallVectorImpl<::mlir::Operation *> &results, 
        ::mlir::transform::TransformState &state);
  }];
}

def VectorToWarpExecuteOnLane0Op : Op<Transform_Dialect, "iree.vector.to_warp_execute_on_lane_0",
    [FunctionalStyleTransformOpTrait, 
     MemoryEffectsOpInterface,
     TransformEachOpTrait, 
     TransformOpInterface]> {
  let description = [{
    Given an scf.if target predicated by `if (threadIdx.x == 0)`, rewrite its 
    body to vector.execute_on_lane_0 running ***on a single warp***.

    The warp size is determined by the `warp_size` attribute (it is generally 
    32 but we do not want to hardcode it).

    This rewrite only applies if it can be determined from the IR (i.e. from 
    the surrounding IREE::HAL::ExecutableExportOp) that the number of threads
    along the warp dimension is a multiple of the warp size. The transformation
    bails on non-perfect multiples of the warp size that would not properly 
    distribute.

    This is the first of two step towards apply vector distribution to a single
    warp.


    Return modes:
    =============
    This operation ignores non-scf::IfOp ops and drops them in the return.

    If all the operations referred to by the `target` PDLOperation are properly
    properly, the transform succeeds. Otherwise the transform silently fails.
    
    If the transform is anchored at a top-level that is not isolated from above,
    the transform definitely fails.

    If the transform cannot find a proper HAL::ExecutableExportOp with a 
    well-formed workgroup_size 3-entry attribute such that the threadIdx.x 
    component is a multiple of warp_size, the transform silently fails.
    If the scf::ForOp predicate does not predicate on threadIdx.x == 0, the 
    transform silently fails.

    Otherwise the transformation succeeds and the returned handle points to the
    produced vector::WarpExecuteOnThread0Op.


    Example:
    ========

    ```
    hal.executable.export public @foo ... { workgroup_size = [64: index, 1: index, 1: index] }
    builtin.module {
      func.func @foo() {
        %c0 = arith.constant 0 : index
        %c1 = arith.constant 1 : index
        %0 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : memref<128xf32>
        %1 = gpu.thread_id  x
        %2 = arith.cmpi ult, %1, %c1 : index
        scf.if %2 {
          %3 = arith.constant dense<1.0> : vector<128xf32>
          vector.transfer_write %3, %0[%c0] : vector<128xf32>, memref<128xf32>
        }
      }
    }
    ```

    rewrites to:

    ```
    hal.executable.export public @foo ... { workgroup_size = [64: index, 1: index, 1: index] }
    builtin.module {
      func.func @foo() {
        %c0 = arith.constant 0 : index
        %c4 = arith.constant 4 : index
        %c32 = arith.constant 32 : index
        %cst = arith.constant dense<1.000000e+00> : vector<128xf32>
        %0 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : memref<128xf32>
        %1 = gpu.thread_id  x
        %2 = arith.cmpi ult, %1, %c32 : index
        // Single-warp guard filters out threads 32-63.
        scf.if %2 {
          vector.warp_execute_on_lane_0(%1)[32] {
            %cst = arith.constant dense<1.000000e+00> : vector<128xf32>
            vector.transfer_write %cst, %0[%c0] : vector<128xf32>, memref<128xf32>
          }
        }
      }
    }
    ```
  }];

  let arguments = (ins PDL_Operation:$target,
                   DefaultValuedAttr<I64Attr, "{}">:$warp_size);
  let results = (outs PDL_Operation:$result);

  let assemblyFormat = "$target attr-dict";
  let cppNamespace = "mlir::iree_compiler::IREE::transform_dialect";

  let extraClassDeclaration = [{
    ::mlir::DiagnosedSilenceableFailure applyToOne(
        ::mlir::scf::IfOp target,
        ::llvm::SmallVectorImpl<::mlir::Operation *> &results, 
        ::mlir::transform::TransformState &state);
  }];
}

def VectorWarpDistributionOp : Op<Transform_Dialect, "iree.vector.warp_distribute",
    [FunctionalStyleTransformOpTrait, 
     MemoryEffectsOpInterface,
     TransformEachOpTrait, 
     TransformOpInterface]> {
  let description = [{
    Given a vector.warp_execute_on_lane_0, apply the patterns to rewrite into
    distributed form with warp synchronization. This produces IR that runs 
    ***on a single warp***.

    IR that cannot be distributed will be predicated by `if (threadIdx.x == 0)`.

    This is the second step of two for applying vector distribution to a single
    warp.

            
    Return modes:
    =============
    This operation applies a number of patterns to rewrite vector IR into 
    distributed warp form. To apply these patterns, this operation must target 
    an operation that is isolated from above, otherwise the transform definitely
    fails.
  
    Patterns sets are applied in the following order:
      - applyMultiReductionLoweringPatterns
      - applyVectorTransferWriteDistribution
      - applyPropagateVectorDistribution
      - applyWarpExecuteOnLane0ToScf

    If any of the pattern sets fail to apply, the transformation definitely
    fails.

    Otherwise the transformation is successful and no result is returned.


    Example:
    ========

    ```
    hal.executable.export public @foo ... { workgroup_size = [64: index, 1: index, 1: index] }
    builtin.module {
      func.func @foo() {
        %c0 = arith.constant 0 : index
        %c4 = arith.constant 4 : index
        %c32 = arith.constant 32 : index
        %cst = arith.constant dense<1.000000e+00> : vector<128xf32>
        %0 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : memref<128xf32>
        %1 = gpu.thread_id  x
        %2 = arith.cmpi ult, %1, %c32 : index
        // Single-warp guard filters out threads 32-63.
        scf.if %2 {
          vector.warp_execute_on_lane_0(%1)[32] {
            %cst = arith.constant dense<1.000000e+00> : vector<128xf32>
            vector.transfer_write %cst, %0[%c0] : vector<128xf32>, memref<128xf32>
          }
        }
      }
    }
    ```

    distributes to:

    ```
    hal.executable.export public @foo ... { workgroup_size = [64: index, 1: index, 1: index] }
    builtin.module {
      func.func @foo() {
        %c0 = arith.constant 0 : index
        %c4 = arith.constant 4 : index
        %c32 = arith.constant 32 : index
        %cst = arith.constant dense<1.000000e+00> : vector<128xf32>
        %0 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : memref<128xf32>
        %1 = gpu.thread_id  x
        %2 = arith.cmpi ult, %1, %c32 : index
        // Single-warp guard filters out threads 32-63.
        scf.if %2 {
          %3 = arith.cmpi eq, %1, %c0 : index
          %4 = memref.alloc() : memref<128xf32, 3>
          // Single-thread guard runs on thread 0 only.
          scf.if %3 {
            vector.store %cst, %4[%c0] : memref<128xf32, 3>, vector<128xf32>
          }
          %5 = arith.muli %1, %c4 : index
          %6 = vector.load %4[%5] : memref<128xf32, 3>, vector<4xf32>
          %7 = affine.apply #map()[%1]
          vector.transfer_write %6, %0[%7] {in_bounds = [true]} : vector<4xf32>, memref<128xf32>
        }
      }
    }
    ```
  }];

  let arguments = (ins PDL_Operation:$target);
  let results = (outs);

  let assemblyFormat = "$target attr-dict";
  let cppNamespace = "mlir::iree_compiler::IREE::transform_dialect";

  let extraClassDeclaration = [{
    ::mlir::DiagnosedSilenceableFailure applyToOne(
        ::mlir::Operation *target,
        ::llvm::SmallVectorImpl<::mlir::Operation *> &results, 
        ::mlir::transform::TransformState &state);
  }];
}

#endif // IREE_COMPILER_CODEGEN_LLVMGPU_TRANSFORMEXTENSIONS_LLVMGPUEXTENSIONS
