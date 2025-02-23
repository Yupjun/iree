# Copyright 2019 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Testing utilities for IREE.

load("//build_tools/bazel:build_defs.oss.bzl", "iree_runtime_cc_library")

package(
    default_visibility = ["//visibility:public"],
    features = ["layering_check"],
    licenses = ["notice"],  # Apache 2.0
)

iree_runtime_cc_library(
    name = "benchmark",
    srcs = [
        "benchmark_full.cc",
    ],
    hdrs = [
        "benchmark.h",
    ],
    deps = [
        "//runtime/src/iree/base",
        "//runtime/src/iree/base:tracing",
        "@com_google_benchmark//:benchmark",
    ],
)

iree_runtime_cc_library(
    name = "benchmark_main",
    testonly = True,
    srcs = ["benchmark_main.c"],
    deps = [
        ":benchmark",
        "//runtime/src/iree/base/internal:flags",
    ],
)

iree_runtime_cc_library(
    name = "gtest",
    testonly = True,
    hdrs = [
        "gtest.h",
        "status_matchers.h",
    ],
    deps = [
        "//runtime/src/iree/base:cc",
        "@com_google_googletest//:gtest",
    ],
)

iree_runtime_cc_library(
    name = "gtest_main",
    testonly = True,
    srcs = ["gtest_main.cc"],
    tags = ["keep_dep"],
    deps = [
        ":gtest",
        "//runtime/src/iree/base/internal:flags",
        "@com_google_googletest//:gtest",
    ],
)
