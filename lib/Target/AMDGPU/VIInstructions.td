//===-- VIInstructions.td - VI Instruction Defintions ---------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Instruction definitions for VI and newer.
//===----------------------------------------------------------------------===//

let SIAssemblerPredicate = DisableInst, SubtargetPredicate = isVI in {

let DisableSIDecoder = 1 in {

//===----------------------------------------------------------------------===//
// VOP1 Instructions
//===----------------------------------------------------------------------===//

defm V_CVT_F16_U16 : VOP1Inst <vop1<0, 0x39>, "v_cvt_f16_u16", VOP_F16_I16>;
defm V_CVT_F16_I16 : VOP1Inst <vop1<0, 0x3a>, "v_cvt_f16_i16", VOP_F16_I16>;
defm V_CVT_U16_F16 : VOP1Inst <vop1<0, 0x3b>, "v_cvt_u16_f16", VOP_I16_F16>;
defm V_CVT_I16_F16 : VOP1Inst <vop1<0, 0x3c>, "v_cvt_i16_f16", VOP_I16_F16>;
defm V_RCP_F16 : VOP1Inst <vop1<0, 0x3d>, "v_rcp_f16", VOP_F16_F16>;
defm V_SQRT_F16 : VOP1Inst <vop1<0, 0x3e>, "v_sqrt_f16", VOP_F16_F16>;
defm V_RSQ_F16 : VOP1Inst <vop1<0, 0x3f>, "v_rsq_f16", VOP_F16_F16>;
defm V_LOG_F16 : VOP1Inst <vop1<0, 0x40>, "v_log_f16", VOP_F16_F16>;
defm V_EXP_F16 : VOP1Inst <vop1<0, 0x41>, "v_exp_f16", VOP_F16_F16>;
defm V_FREXP_MANT_F16 : VOP1Inst <vop1<0, 0x42>, "v_frexp_mant_f16",
  VOP_F16_F16
>;
defm V_FREXP_EXP_I16_F16 : VOP1Inst <vop1<0, 0x43>, "v_frexp_exp_i16_f16",
  VOP_I16_F16
>;
defm V_FLOOR_F16 : VOP1Inst <vop1<0, 0x44>, "v_floor_f16", VOP_F16_F16>;
defm V_CEIL_F16 : VOP1Inst <vop1<0, 0x45>, "v_ceil_f16", VOP_F16_F16>;
defm V_TRUNC_F16 : VOP1Inst <vop1<0, 0x46>, "v_trunc_f16", VOP_F16_F16>;
defm V_RNDNE_F16 : VOP1Inst <vop1<0, 0x47>, "v_rndne_f16", VOP_F16_F16>;
defm V_FRACT_F16 : VOP1Inst <vop1<0, 0x48>, "v_fract_f16", VOP_F16_F16>;
defm V_SIN_F16 : VOP1Inst <vop1<0, 0x49>, "v_sin_f16", VOP_F16_F16>;
defm V_COS_F16 : VOP1Inst <vop1<0, 0x4a>, "v_cos_f16", VOP_F16_F16>;

//===----------------------------------------------------------------------===//
// VOP2 Instructions
//===----------------------------------------------------------------------===//

let isCommutable = 1 in {

defm V_ADD_F16 : VOP2Inst <vop2<0, 0x1f>, "v_add_f16", VOP_F16_F16_F16>;
defm V_SUB_F16 : VOP2Inst <vop2<0, 0x20>, "v_sub_f16", VOP_F16_F16_F16>;
defm V_SUBREV_F16 : VOP2Inst <vop2<0, 0x21>, "v_subrev_f16", VOP_F16_F16_F16,
  null_frag, "v_sub_f16"
>;
defm V_MUL_F16 : VOP2Inst <vop2<0, 0x22>, "v_mul_f16", VOP_F16_F16_F16>;
defm V_MAC_F16 : VOP2Inst <vop2<0, 0x23>, "v_mac_f16", VOP_F16_F16_F16>;
} // End isCommutable = 1
defm V_MADMK_F16 : VOP2MADK <vop2<0,0x24>, "v_madmk_f16", VOP_MADMK>;
let isCommutable = 1 in {
defm V_MADAK_F16 : VOP2MADK <vop2<0,0x25>, "v_madak_f16", VOP_MADAK>;
defm V_ADD_U16 : VOP2Inst <vop2<0,0x26>, "v_add_u16", VOP_I16_I16_I16>;
defm V_SUB_U16 : VOP2Inst <vop2<0,0x27>, "v_sub_u16" , VOP_I16_I16_I16>;
defm V_SUBREV_U16 : VOP2Inst <vop2<0,0x28>, "v_subrev_u16", VOP_I16_I16_I16>;
defm V_MUL_LO_U16 : VOP2Inst <vop2<0,0x29>, "v_mul_lo_u16", VOP_I16_I16_I16>;
} // End isCommutable = 1
defm V_LSHLREV_B16 : VOP2Inst <vop2<0,0x2a>, "v_lshlrev_b16", VOP_I16_I16_I16>;
defm V_LSHRREV_B16 : VOP2Inst <vop2<0,0x2b>, "v_lshrrev_b16", VOP_I16_I16_I16>;
defm V_ASHRREV_B16 : VOP2Inst <vop2<0,0x2c>, "v_ashrrev_b16", VOP_I16_I16_I16>;
let isCommutable = 1 in {
defm V_MAX_F16 : VOP2Inst <vop2<0,0x2d>, "v_max_f16", VOP_F16_F16_F16>;
defm V_MIN_F16 : VOP2Inst <vop2<0,0x2e>, "v_min_f16", VOP_F16_F16_F16>;
defm V_MAX_U16 : VOP2Inst <vop2<0,0x2f>, "v_max_u16", VOP_I16_I16_I16>;
defm V_MAX_I16 : VOP2Inst <vop2<0,0x30>, "v_max_i16", VOP_I16_I16_I16>;
defm V_MIN_U16 : VOP2Inst <vop2<0,0x31>, "v_min_u16", VOP_I16_I16_I16>;
defm V_MIN_I16 : VOP2Inst <vop2<0,0x32>, "v_min_i16", VOP_I16_I16_I16>;
} // End isCommutable = 1
defm V_LDEXP_F16 : VOP2Inst <vop2<0,0x33>, "v_ldexp_f16", VOP_F16_F16_I16>;

} // let DisableSIDecoder = 1

// Aliases to simplify matching of floating-point instructions that
// are VOP2 on SI and VOP3 on VI.

class SI2_VI3Alias <string name, Instruction inst> : InstAlias <
  name#" $dst, $src0, $src1",
  (inst VGPR_32:$dst, 0, VCSrc_f32:$src0, 0, VCSrc_f32:$src1, 0, 0)
>, PredicateControl {
  let UseInstAsmMatchConverter = 0;
  let AsmVariantName = AMDGPUAsmVariants.VOP3;
}

def : SI2_VI3Alias <"v_ldexp_f32", V_LDEXP_F32_e64_vi>;
def : SI2_VI3Alias <"v_cvt_pkaccum_u8_f32", V_CVT_PKACCUM_U8_F32_e64_vi>;
def : SI2_VI3Alias <"v_cvt_pknorm_i16_f32", V_CVT_PKNORM_I16_F32_e64_vi>;
def : SI2_VI3Alias <"v_cvt_pknorm_u16_f32", V_CVT_PKNORM_U16_F32_e64_vi>;
def : SI2_VI3Alias <"v_cvt_pkrtz_f16_f32", V_CVT_PKRTZ_F16_F32_e64_vi>;

} // End SIAssemblerPredicate = DisableInst, SubtargetPredicate = isVI

let Predicates = [isVI] in {

//===----------------------------------------------------------------------===//
// DPP Patterns
//===----------------------------------------------------------------------===//

def : Pat <
  (int_amdgcn_mov_dpp i32:$src, imm:$dpp_ctrl, imm:$row_mask, imm:$bank_mask,
                      imm:$bound_ctrl),
  (i32 (V_MOV_B32_dpp $src, (as_i32imm $dpp_ctrl), (as_i32imm $row_mask),
                       (as_i32imm $bank_mask), (as_i1imm $bound_ctrl)))
>;

//===----------------------------------------------------------------------===//
// Misc Patterns
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// i16 Patterns
//===----------------------------------------------------------------------===//

def : Pat <
  (i16 imm:$imm),
  (S_MOV_B32 imm:$imm)
>;

def : Pat<
  (i32 (anyext i16:$src)),
  (COPY $src)
>;

// FIXME: We need to use COPY_TO_REGCLASS to work-around the fact that
// REG_SEQUENCE patterns don't support instructions with multiple
// outputs.
def : Pat<
  (i64 (zext i16:$src)),
    (REG_SEQUENCE SReg_64,
      (i32 (COPY_TO_REGCLASS (S_AND_B32 $src, (i32 0xffff)), SGPR_32)), sub0,
      (S_MOV_B32 (i32 0)), sub1)
>;

def : Pat <
  (i64 (sext i16:$src)),
    (REG_SEQUENCE SReg_64, (i32 (S_SEXT_I32_I16 $src)), sub0,
    (i32 (COPY_TO_REGCLASS (S_ASHR_I32 (i32 (S_SEXT_I32_I16 $src)), (i32 31)), SGPR_32)), sub1)
>;

// Same as a 32-bit inreg
def : Pat<
  (i32 (sext i16:$src)),
  (S_SEXT_I32_I16 $src)
>;

def : Pat<
  (i32 (zext i16:$src)),
  (S_AND_B32 (i32 0xffff), $src)
>;

def : Pat<
  (i16 (trunc i32:$src)),
  (COPY $src)
>;

def : Pat<
  (i1 (trunc i16:$src)),
  (COPY $src)
>;


def : Pat <
  (i16 (trunc i64:$src)),
  (EXTRACT_SUBREG $src, sub0)
>;


class ZExt_i16_i1_Pat <SDNode ext> : Pat <
  (i16 (ext i1:$src)),
  (V_CNDMASK_B32_e64 (i32 0), (i32 1), $src)
>;

def : ZExt_i16_i1_Pat<zext>;
def : ZExt_i16_i1_Pat<sext>;
def : ZExt_i16_i1_Pat<anyext>;

def : Pat <
  (i16 (select i1:$src0, i16:$src1, i16:$src2)),
  (V_CNDMASK_B32_e64 $src2, $src1, $src0)
>;

// Note: 16-bit instructions produce a 0 result in the high 16-bits.
multiclass Arithmetic_i16_Pats <SDPatternOperator op, Instruction inst> {

def : Pat<
  (op i16:$src0, i16:$src1),
  (inst i16:$src0, i16:$src1)
>;

def : Pat<
  (i32 (zext (op i16:$src0, i16:$src1))),
  (inst i16:$src0, i16:$src1)
>;

def : Pat<
  (i64 (zext (op i16:$src0, i16:$src1))),
   (REG_SEQUENCE VReg_64,
     (inst i16:$src0, i16:$src1), sub0,
     (S_MOV_B32 (i32 0)), sub1)
>;
}

multiclass Bits_Ops_i16_Pats <SDPatternOperator op, Instruction inst> {

def : Pat<
  (op i16:$src0, i32:$src1),
  (inst i16:$src0, i32:$src1)
>;

def : Pat<
  (i32 (zext (op i16:$src0, i32:$src1))),
  (inst i16:$src0, i32:$src1)
>;


def : Pat<
  (i64 (zext (op i16:$src0, i32:$src1))),
   (REG_SEQUENCE VReg_64,
     (inst i16:$src0, i32:$src1), sub0,
     (S_MOV_B32 (i32 0)), sub1)
>;
}

//conversion patterns

def : Pat<
    (f32 (f16_to_fp i16:$src)),
    (V_CVT_F32_F16_e32 $src)
>;

def : Pat<
    (i16 (fp_to_f16 f32:$src)),
    (V_CVT_F16_F32_e32 $src)
>;

/*
// Note: 16-bit instructions produce a 0 result in the high 16-bits.
multiclass Tenary_i16_Pats <SDPatternOperator op1, SDPatternOperator op2, Instruction inst, SDPatternOperator op3> {
def : Pat<
  (op2 (op1 i16:$src0, i16:$src1), i16:$src2),
  (inst i16:$src0, i16:$src1, i16:$src2)
>;

def : Pat<
  (i32 (op3 (op2 (op1 i16:$src0, i16:$src1), i16:$src2))),
  (inst i16:$src0, i16:$src1, i16:$src2)
>;

def : Pat<
  (i64 (op3 (op2 (op1 i16:$src0, i16:$src1), i16:$src2))),
   (REG_SEQUENCE VReg_64,
     (inst i16:$src0, i16:$src1, i16:$src2), sub0,
     (S_MOV_B32 (i32 0)), sub1)
>;
}

defm: Tenary_i16_Pats<add, mul, V_MAD_U16, zext>;
defm: Tenary_i16_Pats<add, mul, V_MAD_I16, sext>;
*/

/*
def : Pat<
    (add (mul i16:$src0, i16:$src1), i16:$src2),
    (V_MAD_I16 i16:$src0, i16:$src1, i16:$src2)
>; */

// Note: 16-bit instructions produce a 0 result in the high 16-bits.

def : Pat<
  (add (mul i16:$src0, i16:$src1), i16:$src2),
  (V_MAD_I16 i16:$src0, i16:$src1, i16:$src2)
>;

def : Pat<
  (i32 (sext (add (mul i16:$src0, i16:$src1), i16:$src2))),
  (V_MAD_I16 i16:$src0, i16:$src1, i16:$src2)
>;

def : Pat<
  (i64 (sext (add (mul i16:$src0, i16:$src1), i16:$src2))),
   (REG_SEQUENCE VReg_64,
     (V_MAD_I16 i16:$src0, i16:$src1, i16:$src2), sub0,
     (S_MOV_B32 (i32 0)), sub1)
>;

def : Pat<
  (add (mul i16:$src0, i16:$src1), i16:$src2),
  (V_MAD_U16 i16:$src0, i16:$src1, i16:$src2)
>;

def : Pat<
  (i32 (zext (add (mul i16:$src0, i16:$src1), i16:$src2))),
  (V_MAD_U16 i16:$src0, i16:$src1, i16:$src2)
>;

def : Pat<
  (i64 (zext (add (mul i16:$src0, i16:$src1), i16:$src2))),
   (REG_SEQUENCE VReg_64,
     (V_MAD_U16 i16:$src0, i16:$src1, i16:$src2), sub0,
     (S_MOV_B32 (i32 0)), sub1)
>;
//////////////////////////////////////////////////////////

//defm: Tenary_i16_Pats<add, mul, V_MAD_I16>;



defm : Arithmetic_i16_Pats<mul, V_MUL_F16_e32>;

defm : Arithmetic_i16_Pats<add, V_ADD_U16_e32>;
defm : Arithmetic_i16_Pats<sub, V_SUB_U16_e32>;
defm : Arithmetic_i16_Pats<smin, V_MIN_I16_e32>;
defm : Arithmetic_i16_Pats<smax, V_MAX_I16_e32>;
defm : Arithmetic_i16_Pats<umin, V_MIN_U16_e32>;
defm : Arithmetic_i16_Pats<umax, V_MAX_U16_e32>;


defm : Arithmetic_i16_Pats<and, V_AND_B32_e32>;
defm : Arithmetic_i16_Pats<or, V_OR_B32_e32>;
defm : Arithmetic_i16_Pats<xor, V_XOR_B32_e32>;


defm : Bits_Ops_i16_Pats<shl, V_LSHLREV_B16_e32>;
defm : Bits_Ops_i16_Pats<srl, V_LSHRREV_B16_e32>;
defm : Bits_Ops_i16_Pats<sra, V_ASHRREV_B16_e32>;
} // End Predicates = [isVI]
