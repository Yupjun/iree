# Copyright 2020 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Utilities for working with IREE MLIR types.

load("//build_tools/bazel:build_defs.oss.bzl", "iree_compiler_cc_library")

package(
    default_visibility = ["//visibility:public"],
    features = ["layering_check"],
    licenses = ["notice"],  # Apache 2.0
)

iree_compiler_cc_library(
    name = "Utils",
    srcs = [
        "GPUUtils.cpp",
        "LinkingUtils.cpp",
        "MarkerUtils.cpp",
        "Utils.cpp",
    ],
    hdrs = [
        "GPUUtils.h",
        "LinkingUtils.h",
        "MarkerUtils.h",
        "Utils.h",
    ],
    deps = [
        "//compiler/src/iree/compiler/Codegen/Interfaces:PartitionableLoopsInterface",
        "//compiler/src/iree/compiler/Codegen/Interfaces:ProcessorOpInterfaces",
        "//compiler/src/iree/compiler/Dialect/Flow/IR",
        "//compiler/src/iree/compiler/Dialect/HAL/IR",
        "//llvm-external-projects/iree-dialects:IREELinalgExtDialect",
        "@llvm-project//llvm:Support",
        "@llvm-project//mlir:AffineDialect",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:GPUDialect",
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:LinalgDialect",
        "@llvm-project//mlir:LinalgTransforms",
        "@llvm-project//mlir:LinalgUtils",
        "@llvm-project//mlir:MemRefDialect",
        "@llvm-project//mlir:Support",
        "@llvm-project//mlir:TensorDialect",
        "@llvm-project//mlir:TilingInterface",
    ],
)
