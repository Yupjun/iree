// RUN: iree-opt --iree-flow-cleanup-tensor-shapes --split-input-file --verify-diagnostics %s | FileCheck  %s

// Tests that we strip out shape metadata ops.

// CHECK-LABEL: @stripTieShape
// CHECK-SAME: (%[[ARG0:.+]]: tensor<?xi32>, %[[ARG1:.+]]: index)
func.func @stripTieShape(%arg0: tensor<?xi32>, %arg1: index) {
  // CHECK-NOT: flow.tensor.tie_shape
  %0 = flow.tensor.tie_shape %arg0 : tensor<?xi32>{%arg1}
  // CHECK: util.do_not_optimize(%[[ARG0]])
  %1 = util.do_not_optimize(%0) : tensor<?xi32>
  return
}

// -----

// Tests that we emit an error if any tensor.dim ops remain.
// They should have all been resolved as part of the lowering through the flow
// pipeline and if they haven't been by now there's nothing else to lower them
// into.

func.func @invalidTensorDim(%arg0: tensor<?xi32>) {
  %c0 = arith.constant 0 : index
  // expected-error @+1 {{'tensor.dim' op unexpected during shape cleanup}}
  %0 = tensor.dim %arg0, %c0 : tensor<?xi32>
  %1 = util.do_not_optimize(%0) : index
  return
}
