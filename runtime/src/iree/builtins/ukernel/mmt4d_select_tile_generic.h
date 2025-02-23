// Copyright 2022 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_BUILTINS_UKERNEL_MMT4D_GENERIC_H_
#define IREE_BUILTINS_UKERNEL_MMT4D_GENERIC_H_

#include "iree/builtins/ukernel/mmt4d_types.h"

// On success, *out_tile_func is the generic tile function to use to perform the
// mmt4d with the given *params. The caller may want to first try to get an
// optimized architecture-specific tile function before falling back on this.
iree_ukernel_mmt4d_status_t iree_ukernel_mmt4d_select_tile_func_generic(
    const iree_ukernel_mmt4d_params_t* params,
    iree_ukernel_mmt4d_tile_func_t* out_tile_func);

#endif  // IREE_BUILTINS_UKERNEL_MMT4D_GENERIC_H_
