# Copyright 2020 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

load("//build_tools/bazel:build_defs.oss.bzl", "iree_cmake_extra_content", "iree_compiler_cc_library", "platform_trampoline_deps")

package(
    default_visibility = ["//visibility:public"],
    features = ["layering_check"],
    licenses = ["notice"],  # Apache 2.0
)

iree_cmake_extra_content(
    content = """
if(NOT IREE_TARGET_BACKEND_LLVM_CPU)
  return()
endif()
""",
)

iree_compiler_cc_library(
    name = "LLVM",
    srcs = [
        "LLVMCPUTarget.cpp",
        "LibraryBuilder.cpp",
    ],
    hdrs = [
        "LLVMCPUTarget.h",
        "LibraryBuilder.h",
    ],
    deps = [
        ":LLVMIRPasses",
        ":LLVMTargetOptions",
        ":LinkerTool",
        ":StaticLibraryGenerator",
        "//compiler/src/iree/compiler/Codegen:PassHeaders",
        "//compiler/src/iree/compiler/Codegen/Common",
        "//compiler/src/iree/compiler/Codegen/Dialect:IREECodegenDialect",
        "//compiler/src/iree/compiler/Codegen/LLVMCPU",
        "//compiler/src/iree/compiler/Codegen/Utils",
        "//compiler/src/iree/compiler/Dialect/HAL/Target",
        "//compiler/src/iree/compiler/Dialect/HAL/Target/LLVM/Builtins",
        "//compiler/src/iree/compiler/Utils",
        "//llvm-external-projects/iree-dialects:IREELinalgExtDialect",
        "//llvm-external-projects/iree-dialects:IREELinalgTransformDialect",
        "@llvm-project//llvm:AArch64AsmParser",
        "@llvm-project//llvm:AArch64CodeGen",
        "@llvm-project//llvm:ARMAsmParser",
        "@llvm-project//llvm:ARMCodeGen",
        "@llvm-project//llvm:Analysis",
        "@llvm-project//llvm:BitReader",
        "@llvm-project//llvm:BitWriter",
        "@llvm-project//llvm:Core",
        "@llvm-project//llvm:Linker",
        "@llvm-project//llvm:RISCVAsmParser",
        "@llvm-project//llvm:RISCVCodeGen",
        "@llvm-project//llvm:Support",
        "@llvm-project//llvm:WebAssemblyAsmParser",
        "@llvm-project//llvm:WebAssemblyCodeGen",
        "@llvm-project//llvm:X86AsmParser",
        "@llvm-project//llvm:X86CodeGen",
        "@llvm-project//llvm:config",
        "@llvm-project//mlir:ArmNeonDialect",
        "@llvm-project//mlir:LLVMDialect",
        "@llvm-project//mlir:LLVMToLLVMIRTranslation",
        "@llvm-project//mlir:PDLDialect",
        "@llvm-project//mlir:PDLInterpDialect",
        "@llvm-project//mlir:ToLLVMIRTranslation",
        "@llvm-project//mlir:TransformDialect",
    ],
)

iree_compiler_cc_library(
    name = "LLVMIRPasses",
    srcs = [
        "LLVMIRPasses.cpp",
    ],
    hdrs = [
        "LLVMIRPasses.h",
    ],
    deps = [
        ":LLVMTargetOptions",
        "@llvm-project//llvm:Analysis",
        "@llvm-project//llvm:Core",
        "@llvm-project//llvm:Instrumentation",
        "@llvm-project//llvm:MC",
        "@llvm-project//llvm:Passes",
        "@llvm-project//llvm:Support",
        "@llvm-project//llvm:Target",
        "@llvm-project//mlir:Support",
    ],
)

iree_compiler_cc_library(
    name = "LLVMTargetOptions",
    srcs = [
        "LLVMTargetOptions.cpp",
    ],
    hdrs = [
        "LLVMTargetOptions.h",
    ],
    deps = [
        "@llvm-project//llvm:MC",
        "@llvm-project//llvm:Passes",
        "@llvm-project//llvm:Support",
        "@llvm-project//llvm:Target",
    ],
)

iree_compiler_cc_library(
    name = "LinkerTool",
    srcs = ["LinkerTool.cpp"],
    hdrs = ["LinkerTool.h"],
    deps = platform_trampoline_deps("LinkerTools", "compiler/src/iree/compiler/Dialect/HAL/Target/LLVM") + [
        "//compiler/src/iree/compiler/Utils",
        "@llvm-project//llvm:Support",
    ],
)

iree_compiler_cc_library(
    name = "LinkerTool_hdrs",
    hdrs = ["LinkerTool.h"],
    deps = [
        ":LLVMTargetOptions",
        "@llvm-project//llvm:Core",
        "@llvm-project//llvm:Support",
        "@llvm-project//mlir:Support",
    ],
)

iree_compiler_cc_library(
    name = "StaticLibraryGenerator",
    srcs = [
        "StaticLibraryGenerator.cpp",
    ],
    hdrs = [
        "StaticLibraryGenerator.h",
    ],
    deps = [
        "@llvm-project//llvm:Support",
    ],
)
