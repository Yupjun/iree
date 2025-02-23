# Copyright 2019 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

load("//build_tools/bazel:build_defs.oss.bzl", "iree_cmake_extra_content", "iree_compiler_cc_library")
load("//build_tools/bazel:iree_tablegen.bzl", "iree_gentbl_cc_library")

package(
    default_visibility = ["//visibility:public"],
    features = ["layering_check"],
    licenses = ["notice"],  # Apache 2.0
)

iree_gentbl_cc_library(
    name = "PassesIncGen",
    tbl_outs = [
        (
            ["--gen-pass-decls"],
            "Passes.h.inc",
        ),
    ],
    tblgen = "@llvm-project//mlir:mlir-tblgen",
    td_file = "Passes.td",
    deps = [
        "@llvm-project//mlir:PassBaseTdFiles",
    ],
)

iree_compiler_cc_library(
    name = "Transforms",
    srcs = [
        "CaptureDispatchDynamicDims.cpp",
        "CleanupNumericNarrowing.cpp",
        "CleanupTensorShapes.cpp",
        "Convert1X1FilterConv2DToMatmul.cpp",
        "ConvertConv2DToImg2Col.cpp",
        "ConvertLinalgMatmulToMmt4D.cpp",
        "ConvertRegionToWorkgroups.cpp",
        "ConvertToFlow.cpp",
        "DeduplicateExecutables.cpp",
        "DetachElementwiseFromNamedOps.cpp",
        "DispatchLinalgOnTensors.cpp",
        "DispatchLinalgOnTensorsViaRegionOps.cpp",
        "DispatchWithTransformDialect.cpp",
        "DumpDispatchGraph.cpp",
        "ExpandTensorShapes.cpp",
        "ExportBenchmarkFuncs.cpp",
        "FusionOfTensorOps.cpp",
        "InferNumericNarrowing.cpp",
        "InitializeEmptyTensors.cpp",
        "InjectDispatchTracing.cpp",
        "InterchangeGenericOps.cpp",
        "InterchangeTransposeGenericOps.cpp",
        "OptimizeNumerics.cpp",
        "OutlineDispatchRegions.cpp",
        "PadLinalgOps.cpp",
        "PassDetail.h",
        "Passes.cpp",
        "RegionOpUtils.cpp",
        "SplitReduction.cpp",
        "StripAndSplatConstantVariables.cpp",
        "StripSignedness.cpp",
        "TensorPadToTensorInsertSlice.cpp",
        "VerifyInputLegality.cpp",
    ],
    hdrs = [
        "ConvertRegionToWorkgroups.h",
        "DispatchLinalgOnTensors.h",
        "Passes.h",
        "Passes.h.inc",
        "RegionOpUtils.h",
    ],
    deps = [
        ":PassesIncGen",
        "//compiler/src/iree/compiler/Dialect/Flow/Conversion/TensorToFlow",
        "//compiler/src/iree/compiler/Dialect/Flow/IR",
        "//compiler/src/iree/compiler/Dialect/HAL/IR",
        "//compiler/src/iree/compiler/Dialect/Util/Analysis",
        "//compiler/src/iree/compiler/Dialect/Util/Analysis/Attributes",
        "//compiler/src/iree/compiler/Dialect/Util/Analysis/DFX",
        "//compiler/src/iree/compiler/Dialect/Util/IR",
        "//compiler/src/iree/compiler/Dialect/Util/Transforms",
        "//compiler/src/iree/compiler/Utils",
        "//llvm-external-projects/iree-dialects:IREELinalgExtDialect",
        "//llvm-external-projects/iree-dialects:IREELinalgExtPasses",
        "//llvm-external-projects/iree-dialects:IREELinalgExtTransformOps",
        "//llvm-external-projects/iree-dialects:IREELinalgTransformDialect",
        "//llvm-external-projects/iree-dialects:IREELinalgTransformDialectPasses",
        "@llvm-project//llvm:Support",
        "@llvm-project//mlir:AffineDialect",
        "@llvm-project//mlir:Analysis",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:ArithUtils",
        "@llvm-project//mlir:ControlFlowDialect",
        "@llvm-project//mlir:DialectUtils",
        "@llvm-project//mlir:FuncDialect",
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:LinalgDialect",
        "@llvm-project//mlir:LinalgTransforms",
        "@llvm-project//mlir:LinalgUtils",
        "@llvm-project//mlir:MathDialect",
        "@llvm-project//mlir:MemRefDialect",
        "@llvm-project//mlir:MemRefTransforms",
        "@llvm-project//mlir:PDLDialect",
        "@llvm-project//mlir:PDLInterpDialect",
        "@llvm-project//mlir:Parser",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:SCFDialect",
        "@llvm-project//mlir:Support",
        "@llvm-project//mlir:TensorDialect",
        "@llvm-project//mlir:TensorUtils",
        "@llvm-project//mlir:TilingInterface",
        "@llvm-project//mlir:TosaDialect",
        "@llvm-project//mlir:TransformDialect",
        "@llvm-project//mlir:TransformUtils",
        "@llvm-project//mlir:Transforms",
    ],
)

# TODO(#4919): For an unknown reason, GCC's devirtualization optimization wreaks
# havoc on this file. Needs to be further root caused. Seems to affect both 9.x
# and 10.x.
iree_cmake_extra_content(
    content = """
set_property(SOURCE
  DispatchLinalgOnTensors.cpp
  PROPERTY COMPILE_FLAGS $<$<CXX_COMPILER_ID:GNU>:-fno-devirtualize>)
""",
    inline = True,
)
