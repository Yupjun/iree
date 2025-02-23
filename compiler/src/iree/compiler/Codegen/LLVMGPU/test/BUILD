# Copyright 2021 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Tests for common transforms.

load("//build_tools/bazel:iree_lit_test.bzl", "iree_lit_test_suite")
load("//build_tools/bazel:enforce_glob.bzl", "enforce_glob")

package(
    features = ["layering_check"],
    licenses = ["notice"],  # Apache 2.0
)

iree_lit_test_suite(
    name = "lit",
    srcs = enforce_glob(
        [
            "conv_pipeline_test.mlir",
            "convert_to_nvvm.mlir",
            "convert_to_rocdl.mlir",
            "distribute_to_thread.mlir",
            "distribute_foreach.mlir",
            "gpu_set_num_workgroups.mlir",
            "nvvm_pipeline_test.mlir",
            "reduce_bank_conflicts.mlir",
            "rocdl_pipeline_test.mlir",
            "illegal_configuration.mlir",
            "linalg_transform.mlir",
            "legalize.mlir",
            "tensor_alloc.mlir",
            "tensorcore_vectorization.mlir",
            "tile_on_tensor.mlir",
            "transform_dialect_vector_distribution.mlir",
            "transform_dialect_bufferize.mlir",
            "transpose_pipeline_test.mlir",
            "vector_to_gpu.mlir",
        ],
        include = ["*.mlir"],
        # tensor_dialect_*_spec is a an MLIR file that specifies a
        # transformation, it needs to be included as data.
        exclude = [
            "transform_dialect_codegen_bufferize_spec.mlir",
            "transform_dialect_codegen_foreach_to_gpu_spec.mlir",
            "transform_dialect_codegen_vector_distribution_spec.mlir",
            "transform_dialect_codegen_vector_warp_execute_on_lane_0_spec.mlir",
        ],
    ),
    cfg = "//compiler:lit.cfg.py",
    data = [
        "transform_dialect_codegen_bufferize_spec.mlir",
        "transform_dialect_codegen_foreach_to_gpu_spec.mlir",
        "transform_dialect_codegen_vector_distribution_spec.mlir",
        "transform_dialect_codegen_vector_warp_execute_on_lane_0_spec.mlir",
    ],
    tools = [
        "//tools:iree-opt",
        "@llvm-project//llvm:FileCheck",
    ],
)
