#include "assembly.h"

// TODO: share these bits with C/C++.
.equ ACCUMULATE_FLAG_BIT_POS,0

// Parameters:
//   x0: int32_t* out_tile
//   x1: const int8_t* lhs_panel
//   x2: const int8_t* rhs_panel
//   w3: int32_t K. Note: K>=1, as the K==0 case was handled as an early-return.
//   w4: uint32_t flags
//   x5: (UNUSED) params - relevant params K and flags already passed above.

BEGIN_FUNCTION iree_ukernel_mmt4d_f32f32f32_tile_8x8x1_arm_64

        // Do we accumulate into or clear the accumulator tile?
        tbnz w4, ACCUMULATE_FLAG_BIT_POS, 1f

    0:
        // No-accumulate case. Clear the 8x8 accumulator tile.
        movi v16.16b, 0
        movi v17.16b, 0
        movi v18.16b, 0
        movi v19.16b, 0
        movi v20.16b, 0
        movi v21.16b, 0
        movi v22.16b, 0
        movi v23.16b, 0
        movi v24.16b, 0
        movi v25.16b, 0
        movi v26.16b, 0
        movi v27.16b, 0
        movi v28.16b, 0
        movi v29.16b, 0
        movi v30.16b, 0
        movi v31.16b, 0
        b 2f
  
    1:
        // Accumulate case. Load the 8x8 accumulator tile from row-major
        // out_tile, into temporary registers v16--v31.
        ldp q16, q17, [x0, 0]
        ldp q18, q19, [x0, 32]
        ldp q20, q21, [x0, 64]
        ldp q22, q23, [x0, 96]
        ldp q24, q25, [x0, 128]
        ldp q26, q27, [x0, 160]
        ldp q28, q29, [x0, 192]
        ldp q30, q31, [x0, 224]
        
    2:
        // Loop body. Decrement the loop counter K.
        subs w3, w3, 1
        // Load 8x1 LHS tile
        ldp q0, q1, [x1, 0]
        add x1, x1, 32
        // Load 8x1 RHS tile
        ldp q4, q5, [x2, 0]
        add x2, x2, 32
        // Multiply-accumulate, row 0.
        fmla v16.4s, v4.4s, v0.s[0]
        fmla v17.4s, v5.4s, v0.s[0]
        // Multiply-accumulate, row 1.
        fmla v18.4s, v4.4s, v0.s[1]
        fmla v19.4s, v5.4s, v0.s[1]
        // Multiply-accumulate, row 2.
        fmla v20.4s, v4.4s, v0.s[2]
        fmla v21.4s, v5.4s, v0.s[2]
        // Multiply-accumulate, row 3.
        fmla v22.4s, v4.4s, v0.s[3]
        fmla v23.4s, v5.4s, v0.s[3]
        // Multiply-accumulate, row 4.
        fmla v24.4s, v4.4s, v1.s[0]
        fmla v25.4s, v5.4s, v1.s[0]
        // Multiply-accumulate, row 5.
        fmla v26.4s, v4.4s, v1.s[1]
        fmla v27.4s, v5.4s, v1.s[1]
        // Multiply-accumulate, row 6.
        fmla v28.4s, v4.4s, v1.s[2]
        fmla v29.4s, v5.4s, v1.s[2]
        // Multiply-accumulate, row 7.
        fmla v30.4s, v4.4s, v1.s[3]
        fmla v31.4s, v5.4s, v1.s[3]
        // Loop if K != 0.
        b.ne 2b

    3:
        // Store the accumulator tile to the destination.
        stp q16, q17, [x0, 0]
        stp q18, q19, [x0, 32]
        stp q20, q21, [x0, 64]
        stp q22, q23, [x0, 96]
        stp q24, q25, [x0, 128]
        stp q26, q27, [x0, 160]
        stp q28, q29, [x0, 192]
        stp q30, q31, [x0, 224]
        ret

END_FUNCTION iree_ukernel_mmt4d_f32f32f32_tile_8x8x1_arm_64

BEGIN_FUNCTION iree_ukernel_mmt4d_i8i8i32_tile_8x8x1_arm_64

        // Do we accumulate into or clear the accumulator tile?
        tbnz w4, ACCUMULATE_FLAG_BIT_POS, 1f

    0:
        // No-accumulate case. Clear the 8x8 accumulator tile.
        movi v16.16b, 0
        movi v17.16b, 0
        movi v18.16b, 0
        movi v19.16b, 0
        movi v20.16b, 0
        movi v21.16b, 0
        movi v22.16b, 0
        movi v23.16b, 0
        movi v24.16b, 0
        movi v25.16b, 0
        movi v26.16b, 0
        movi v27.16b, 0
        movi v28.16b, 0
        movi v29.16b, 0
        movi v30.16b, 0
        movi v31.16b, 0
        b 2f
  
    1:
        // Accumulate case. Load the 8x8 accumulator tile from row-major
        // out_tile, into temporary registers v16--v31.
        ldp q16, q17, [x0, 0]
        ldp q18, q19, [x0, 32]
        ldp q20, q21, [x0, 64]
        ldp q22, q23, [x0, 96]
        ldp q24, q25, [x0, 128]
        ldp q26, q27, [x0, 160]
        ldp q28, q29, [x0, 192]
        ldp q30, q31, [x0, 224]
        
    2:
        // Loop body. Decrement the loop counter K.
        subs w3, w3, 1
        // Load 8x1 LHS tile
        ldr d0, [x1, 0]
        add x1, x1, 8
        // Load 8x4 RHS tile
        ldr d4, [x2, 0]
        add x2, x2, 8
        sxtl v1.8h, v0.8b
        sxtl v5.8h, v4.8b
        smlal v16.4s, v5.4h, v1.h[0]
        smlal2 v17.4s, v5.8h, v1.h[0]
        smlal v18.4s, v5.4h, v1.h[1]
        smlal2 v19.4s, v5.8h, v1.h[1]
        smlal v20.4s, v5.4h, v1.h[2]
        smlal2 v21.4s, v5.8h, v1.h[2]
        smlal v22.4s, v5.4h, v1.h[3]
        smlal2 v23.4s, v5.8h, v1.h[3]
        smlal v24.4s, v5.4h, v1.h[4]
        smlal2 v25.4s, v5.8h, v1.h[4]
        smlal v26.4s, v5.4h, v1.h[5]
        smlal2 v27.4s, v5.8h, v1.h[5]
        smlal v28.4s, v5.4h, v1.h[6]
        smlal2 v29.4s, v5.8h, v1.h[6]
        smlal v30.4s, v5.4h, v1.h[7]
        smlal2 v31.4s, v5.8h, v1.h[7]
        // Loop if K != 0.
        b.ne 2b

    3:
        // Store the accumulator tile to the destination.
        stp q16, q17, [x0, 0]
        stp q18, q19, [x0, 32]
        stp q20, q21, [x0, 64]
        stp q22, q23, [x0, 96]
        stp q24, q25, [x0, 128]
        stp q26, q27, [x0, 160]
        stp q28, q29, [x0, 192]
        stp q30, q31, [x0, 224]
        ret

END_FUNCTION iree_ukernel_mmt4d_i8i8i32_tile_8x8x1_arm_64

ALLOW_NON_EXECUTABLE_STACK
