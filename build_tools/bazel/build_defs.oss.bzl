# Copyright 2019 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Common Bazel definitions for IREE."""

def platform_trampoline_deps(basename, path = "runtime/src/iree/base"):
    """Produce a list of deps for the given `basename` platform target.

    Example:
      "file_mapping" -> ["//iree/base/internal/file_mapping_internal"]

    This is used for compatibility with various methods of including the
    library in foreign source control systems.

    Args:
      basename: Library name prefix for a library in [path]/internal.
      path: Folder name to work within.
    Returns:
      A list of dependencies for depending on the library in a platform
      sensitive way.
    """
    return [
        "//%s/internal:%s_internal" % (path, basename),
    ]

def iree_build_test(name, targets):
    """Dummy rule to ensure that targets build.

    This is currently undefined in bazel and is preserved for compatibility.
    """
    pass

def iree_cmake_extra_content(content = "", inline = False):
    """Tool for inserting arbitrary content during Bazel->CMake conversion.

    This does nothing in Bazel, while the contents are inserted as-is in
    converted CMakeLists.txt files.

    Args:
      content: The text to insert into the converted file.
      inline: If true, the content will be inserted inline. Otherwise, it will
        be inserted near the top of the converted file.
    """
    pass

def iree_compiler_cc_library(deps = [], **kwargs):
    """Used for cc_library targets within the //compiler tree.

    This is a pass-through to the native cc_library which adds specific
    compiler specific options and deps.
    """
    native.cc_library(
        deps = deps + [
            "//compiler/src:defs",
        ],
        **kwargs
    )

def iree_runtime_cc_library(deps = [], **kwargs):
    """Used for cc_library targets within the //runtime tree.

    This is a pass-through to the native cc_library which adds specific
    runtime specific options and deps.
    """
    native.cc_library(
        deps = deps + [
            # TODO: Rename to //runtime/src:defs to match compiler.
            "//runtime/src:runtime_defines",
        ],
        **kwargs
    )

def iree_runtime_cc_test(deps = [], **kwargs):
    """Used for cc_test targets within the //runtime tree.

    This is a pass-through to the native cc_test which adds specific
    runtime specific options and deps.
    """
    native.cc_test(
        deps = deps + [
            # TODO: Rename to //runtime/src:defs to match compiler.
            "//runtime/src:runtime_defines",
        ],
        **kwargs
    )
