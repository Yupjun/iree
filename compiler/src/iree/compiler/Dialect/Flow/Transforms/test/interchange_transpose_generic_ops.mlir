// RUN: iree-opt --split-input-file --verify-diagnostics --iree-flow-interchange-transpose-generic-ops --canonicalize -cse %s | FileCheck %s

func.func @batch_matmul_transpose(%a: tensor<4x384x384xf32>, %b: tensor<4x384x32xf32>) -> tensor<384x4x32xf32> {
  %cst = arith.constant 0.000000e+00 : f32
  %init = linalg.init_tensor [4, 384, 32] : tensor<4x384x32xf32>
  %c = linalg.fill ins(%cst : f32) outs(%init : tensor<4x384x32xf32>) -> tensor<4x384x32xf32>
  %matmul = linalg.batch_matmul ins(%a, %b : tensor<4x384x384xf32>, tensor<4x384x32xf32>) outs(%c : tensor<4x384x32xf32>) -> tensor<4x384x32xf32>
  %result = linalg.init_tensor [384, 4, 32] : tensor<384x4x32xf32>
  %transpose = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d1, d0, d2)>, affine_map<(d0, d1, d2) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel"]} ins(%matmul : tensor<4x384x32xf32>) outs(%result : tensor<384x4x32xf32>) {
  ^bb0(%arg0: f32, %arg1: f32):
    linalg.yield %arg0 : f32
  } -> tensor<384x4x32xf32>
  return %transpose : tensor<384x4x32xf32>
}

// Check that linalg.generic's input and output indexing maps are exchanged.

//      CHECK: #map0 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
//      CHECK: #map1 = affine_map<(d0, d1, d2) -> (d1, d0, d2)>
// CHECK-LABEL: func.func @batch_matmul_transpose
//      CHECK:   %[[MATMUL:.+]] = linalg.batch_matmul
//      CHECK:   linalg.generic
// CHECK-SAME:     indexing_maps = [#map0, #map1]
// CHECK-SAME:     outs(%[[OUT:.+]] : tensor<384x4x32xf32>)

// -----

func.func @matmul_transpose(%a: tensor<128x384xf32>, %b: tensor<384x384xf32>) -> tensor<384x128xf32> {
  %cst = arith.constant 0.000000e+00 : f32
  %cst1 = arith.constant 1.000000e+00 : f32
  %init = linalg.init_tensor [128, 384] : tensor<128x384xf32>
  %c = linalg.fill ins(%cst : f32) outs(%init : tensor<128x384xf32>) -> tensor<128x384xf32>
  %matmul = linalg.matmul ins(%a, %b : tensor<128x384xf32>, tensor<384x384xf32>) outs(%c : tensor<128x384xf32>) -> tensor<128x384xf32>
  %result = linalg.init_tensor [384, 128] : tensor<384x128xf32>
  %transpose = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d1, d0)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%matmul : tensor<128x384xf32>) outs(%result : tensor<384x128xf32>) {
  ^bb0(%arg0: f32, %arg1: f32):
    %add = arith.addf %arg0, %cst1 : f32
    linalg.yield %add : f32
  } -> tensor<384x128xf32>
  return %transpose : tensor<384x128xf32>
}

// Check that linalg.generic's input and output indexing maps are exchanged.

//      CHECK: #map0 = affine_map<(d0, d1) -> (d0, d1)>
//      CHECK: #map1 = affine_map<(d0, d1) -> (d1, d0)>
// CHECK-LABEL: func.func @matmul_transpose
//      CHECK:   %[[MATMUL:.+]] = linalg.matmul
//      CHECK:   linalg.generic
// CHECK-SAME:     indexing_maps = [#map0, #map1]
// CHECK-SAME:     ins(%[[MATMUL]] : tensor<128x384xf32>
// CHECK-SAME:     outs(%[[OUT:.+]] : tensor<384x128xf32>)
