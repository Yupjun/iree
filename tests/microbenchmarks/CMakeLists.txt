### BAZEL_TO_CMAKE_PRESERVES_ALL_CONTENT_BELOW_THIS_LINE ###

iree_add_all_subdirs()

iree_microbenchmark_suite(
  NAME
   "microbenchmark"
  SRCS
    "dynamic_shape_vectorization.mlir"
    "linalg_mmt4d.mlir"
    "linalg_transpose.mlir"
    "mhlo_conv.mlir"
    "mhlo_dot.mlir"
    "mhlo_dot_general.mlir"
    "mhlo_fft_abs.mlir"
  FLAGS
    "--iree-hal-target-backends=llvm-cpu"
    "--iree-input-type=mhlo"
    "--iree-llvm-target-cpu-features=host"
)
