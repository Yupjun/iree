################################################################################
# Autogenerated by build_tools/bazel_to_cmake/bazel_to_cmake.py from           #
# compiler/src/iree/compiler/Modules/HAL/Inline/Conversion/HALInlineToVM/BUILD #
#                                                                              #
# Use iree_cmake_extra_content from iree/build_defs.oss.bzl to add arbitrary   #
# CMake-only content.                                                          #
#                                                                              #
# To disable autogeneration for this file entirely, delete this header.        #
################################################################################

iree_add_all_subdirs()

iree_cc_library(
  NAME
    HALInlineToVM
  HDRS
    "ConvertHALInlineToVM.h"
  SRCS
    "ConvertHALInlineToVM.cpp"
  DEPS
    MLIRArithDialect
    MLIRFuncDialect
    MLIRIR
    MLIRPass
    MLIRTransforms
    iree::compiler::Dialect::Util::IR
    iree::compiler::Dialect::VM::Conversion
    iree::compiler::Dialect::VM::Conversion::StandardToVM
    iree::compiler::Dialect::VM::IR
    iree::compiler::Modules::HAL::Inline::IR
  PUBLIC
)

### BAZEL_TO_CMAKE_PRESERVES_ALL_CONTENT_BELOW_THIS_LINE ###
