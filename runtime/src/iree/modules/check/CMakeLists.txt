################################################################################
# Autogenerated by build_tools/bazel_to_cmake/bazel_to_cmake.py from           #
# runtime/src/iree/modules/check/BUILD                                         #
#                                                                              #
# Use iree_cmake_extra_content from iree/build_defs.oss.bzl to add arbitrary   #
# CMake-only content.                                                          #
#                                                                              #
# To disable autogeneration for this file entirely, delete this header.        #
################################################################################

iree_add_all_subdirs()

iree_cc_library(
  NAME
    check
  HDRS
    "module.h"
  SRCS
    "module.cc"
  DEPS
    iree::base
    iree::base::cc
    iree::base::internal
    iree::hal
    iree::modules::hal
    iree::testing::gtest
    iree::vm
    iree::vm::cc
  TESTONLY
  PUBLIC
)

iree_cc_test(
  NAME
    check_test
  SRCS
    "check_test.cc"
  DEPS
    ::check
    iree::base
    iree::base::cc
    iree::base::internal
    iree::base::internal::span
    iree::hal
    iree::modules::hal
    iree::testing::gtest
    iree::testing::gtest_main
    iree::tooling::device_util
    iree::vm
    iree::vm::bytecode_module
    iree::vm::cc
)

### BAZEL_TO_CMAKE_PRESERVES_ALL_CONTENT_BELOW_THIS_LINE ###
