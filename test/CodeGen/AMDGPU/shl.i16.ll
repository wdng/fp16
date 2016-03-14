; RUN: llc < %s -march=amdgcn -mcpu=tonga -verify-machineinstrs | FileCheck -check-prefix=GCN -check-prefix=VI %s

declare i32 @llvm.r600.read.tidig.x() #0

;VI: {{^}}shl_v2i16:
;VI: v_lshlrev_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
;VI: v_lshlrev_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}

define void @shl_v2i16(<2 x i16> addrspace(1)* %out, <2 x i16> addrspace(1)* %in) {
  %b_ptr = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %in, i32 1
  %a = load <2 x i16>, <2 x i16> addrspace(1) * %in
  %b = load <2 x i16>, <2 x i16> addrspace(1) * %b_ptr
  %result = shl <2 x i16> %a, %b
  store <2 x i16> %result, <2 x i16> addrspace(1)* %out
  ret void
}

;VI: {{^}}shl_v4i16:
;VI: v_lshlrev_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
;VI: v_lshlrev_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
;VI: v_lshlrev_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
;VI: v_lshlrev_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}

define void @shl_v4i16(<4 x i16> addrspace(1)* %out, <4 x i16> addrspace(1)* %in) {
  %b_ptr = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %in, i32 1
  %a = load <4 x i16>, <4 x i16> addrspace(1) * %in
  %b = load <4 x i16>, <4 x i16> addrspace(1) * %b_ptr
  %result = shl <4 x i16> %a, %b
  store <4 x i16> %result, <4 x i16> addrspace(1)* %out
  ret void
}


;VI: {{^}}shl_i16:
;VI: v_lshlrev_b64 {{v\[[0-9]+:[0-9]+\], v[0-9]+, v\[[0-9]+:[0-9]+\]}}

define void @shl_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %in) {
  %b_ptr = getelementptr i16, i16 addrspace(1)* %in, i16 1
  %a = load i16, i16 addrspace(1) * %in
  %b = load i16, i16 addrspace(1) * %b_ptr
  %result = shl i16 %a, %b
  store i16 %result, i16 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}v_shl_i16_32_bit_constant:
; SI-DAG: buffer_load_dword [[VAL:v[0-9]+]]
; SI-DAG: s_mov_b32 s[[KLO:[0-9]+]], 0x12d687{{$}}
; SI-DAG: s_mov_b32 s[[KHI:[0-9]+]], 0{{$}}
; SI: v_lshl_b64 {{v\[[0-9]+:[0-9]+\]}}, s{{\[}}[[KLO]]:[[KHI]]{{\]}}, [[VAL]]
define void @v_shl_i16_32_bit_constant(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr) {
  %a = load i16, i16 addrspace(1)* %aptr, align 8
  %shl = shl i16 1234567, %a
  store i16 %shl, i16 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}v_shl_inline_imm_8_i16:
; SI: v_lshl_b64 {{v\[[0-9]+:[0-9]+\]}}, 64, {{v[0-9]+}}
define void @v_shl_inline_imm_64_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr) {
  %a = load i16, i16 addrspace(1)* %aptr, align 8
  %shl = shl i16 8, %a
  store i16 %shl, i16 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}s_shl_inline_imm_1_i16:
; SI: s_lshl_b64 s{{\[[0-9]+:[0-9]+\]}}, 1, s{{[0-9]+}}
define void @s_shl_inline_imm_1_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 %a) {
  %shl = shl i16 1, %a
  store i16 %shl, i16 addrspace(1)* %out, align 8
  ret void
}

attributes #0 = { nounwind readnone }
