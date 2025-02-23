// Copyright 2022 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#ifndef IREE_COMPILER_DIALECT_FLOW_TRANSFORMS_REGIONOPUTILS_H_
#define IREE_COMPILER_DIALECT_FLOW_TRANSFORMS_REGIONOPUTILS_H_

#include "llvm/ADT/SmallVector.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Support/LogicalResult.h"

namespace mlir {
class Location;
class OpBuilder;
class Operation;
class RewriterBase;
class Value;

namespace iree_compiler {
namespace IREE {
namespace Flow {
class DispatchRegionOp;

/// For a given operation returns the loop ranges needed to compute the op.
SmallVector<Range> getLoopRanges(Operation *op, Location loc,
                                 OpBuilder &builder);

/// Reify the dynamic dimensions of the given value.
LogicalResult reifyDynamicResultDims(OpBuilder &b, Value value,
                                     SmallVector<Value> &dynamicDims);

/// Append a result to the given DispatchRegionOp. The newly created
/// DispatchRegionOp is returned.
FailureOr<Flow::DispatchRegionOp> appendDispatchRegionResult(
    RewriterBase &rewriter, Flow::DispatchRegionOp regionOp, Value result);

/// Create an empty DispatchRegionOp.
Flow::DispatchRegionOp makeEmptyDispatchRegion(OpBuilder &builder,
                                               Location loc);

/// Clone a `target` op that is preceding the given dispatch region op into the
/// dispatch region.
///
/// All uses of the target inside of the dispatch region are replaced with the
/// results of the cloned op.
///
/// Example:
///
/// %0 = "some_op"() : () -> (tensor<?xf32>)
/// %r = flow.dispatch.region -> (tensor<?xf32>{%d0}) {
///   %1 = "another_op"(%0) : (tensor<?xf32>) -> (tensor<?xf32>)
///   flow.return %1 : tensor<?xf32>
/// }
/// %2 = "yet_another_use"(%0) : (tensor<?xf32>) -> (tensor<?xf32>)
LogicalResult clonePrecedingOpIntoDispatchRegion(
    RewriterBase &rewriter, Operation *target, Flow::DispatchRegionOp regionOp);

/// Move a `target` op that is preceding the given dispatch region op into the
/// dispatch region.
///
/// All uses of the target outside of the dispatch region are replaced with the
/// results of the cloned op.
///
/// Example:
///
/// %0 = "some_op"() : () -> (tensor<?xf32>)
/// %r = flow.dispatch.region -> (tensor<?xf32>{%d0}) {
///   %0_clone = "some_op"() : () -> (tensor<?xf32>)
///   %1 = "another_op"(%0_clone) : (tensor<?xf32>) -> (tensor<?xf32>)
///   flow.return %1 : tensor<?xf32>
/// }
/// %2 = "yet_another_use"(%0) : (tensor<?xf32>) -> (tensor<?xf32>)
FailureOr<Flow::DispatchRegionOp> movePrecedingOpIntoDispatchRegion(
    RewriterBase &rewriter, Operation *target, Flow::DispatchRegionOp regionOp);

/// Wrap the given op in a new dispatch region op.
FailureOr<Flow::DispatchRegionOp> wrapOpInDispatchRegion(RewriterBase &rewriter,
                                                         Operation *op);

/// Sort the given ops topologically, so that they can be inlined into a
/// dispatch region without dominance violations.
///
/// Example:
///
/// %0 = "some_op"()
/// %1 = "another_op"(%1)
///
/// In the above example, "some_op" is before "another_op" in the result.
// TODO: Improve mlir::sortTopologically. This function does currently not
// support ops from different blocks.
SmallVector<Operation *> orderOperations(ArrayRef<Operation *> ops);

}  // namespace Flow
}  // namespace IREE
}  // namespace iree_compiler
}  // namespace mlir

#endif  // IREE_COMPILER_DIALECT_FLOW_TRANSFORMS_REGIONOPUTILS_H_
