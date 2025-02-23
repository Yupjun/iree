// Copyright 2022 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_COMPILER_MODULES_HAL_INLINE_CONVERSION_STREAMTOHALINLINE_CONVERTSTREAMTOHALINLINE_H_
#define IREE_COMPILER_MODULES_HAL_INLINE_CONVERSION_STREAMTOHALINLINE_CONVERTSTREAMTOHALINLINE_H_

#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

namespace mlir {
namespace iree_compiler {

// Populates conversion patterns for stream->HAL (inline).
void populateStreamToHALInlinePatterns(MLIRContext *context,
                                       ConversionTarget &conversionTarget,
                                       TypeConverter &typeConverter,
                                       RewritePatternSet &patterns);

}  // namespace iree_compiler
}  // namespace mlir

#endif  // IREE_COMPILER_MODULES_HAL_INLINE_CONVERSION_STREAMTOHALINLINE_CONVERTSTREAMTOHALINLINE_H_
