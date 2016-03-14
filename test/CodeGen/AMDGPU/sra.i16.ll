; RUN: llc -march=amdgcn -mcpu=tonga -verify-machineinstrs < %s | FileCheck -check-prefix=GCN -check-prefix=VI -check-prefix=FUNC %s

declare i32 @llvm.r600.read.tidig.x() #0

; FUNC-LABEL: {{^}}ashr_v2i16:

; VI: v_ashrrev_i16_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; VI: v_ashrrev_i16_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}

define void @ashr_v2i16(<2 x i16> addrspace(1)* %out, <2 x i16> addrspace(1)* %in) {
  %b_ptr = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %in, i16 1
  %a = load <2 x i16>, <2 x i16> addrspace(1)* %in
  %b = load <2 x i16>, <2 x i16> addrspace(1)* %b_ptr
  %result = ashr <2 x i16> %a, %b
  store <2 x i16> %result, <2 x i16> addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}ashr_v4i16:

; VI: v_ashrrev_i16_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; VI: v_ashrrev_i16_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; VI: v_ashrrev_i16_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; VI: v_ashrrev_i16_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}

define void @ashr_v4i16(<4 x i16> addrspace(1)* %out, <4 x i16> addrspace(1)* %in) {
  %b_ptr = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %in, i16 1
  %a = load <4 x i16>, <4 x i16> addrspace(1)* %in
  %b = load <4 x i16>, <4 x i16> addrspace(1)* %b_ptr
  %result = ashr <4 x i16> %a, %b
  store <4 x i16> %result, <4 x i16> addrspace(1)* %out
  ret void
}


; FUNC-LABEL: {{^}}ashr_i16_2:

; VI: v_ashrrev_i16 {{v\[[0-9]+:[0-9]+\], v[0-9]+, v\[[0-9]+:[0-9]+\]}}

define void @ashr_i16_2(i16 addrspace(1)* %out, i16 addrspace(1)* %in) {
entry:
  %b_ptr = getelementptr i16, i16 addrspace(1)* %in, i16 1
  %a = load i16, i16 addrspace(1)* %in
  %b = load i16, i16 addrspace(1)* %b_ptr
  %result = ashr i16 %a, %b
  store i16 %result, i16 addrspace(1)* %out
  ret void
}

; GCN-LABEL: {{^}}v_ashr_2_i16:
; SI: buffer_load_dword v[[HI:[0-9]+]], {{v\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}, 0 addr64 offset:4
; VI: flat_load_dword v[[HI:[0-9]+]]
; GCN: v_ashrrev_i16_e32 v[[SHIFT:[0-9]+]], 31, v[[HI]]
; GCN: {{buffer|flat}}_store_dwordx2 {{.*}}v{{\[}}[[HI]]:[[SHIFT]]{{\]}}
define void @v_ashr_32_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %in) {
  %tid = call i32 @llvm.r600.read.tidig.x() #0
  %gep.in = getelementptr i16, i16 addrspace(1)* %in, i32 %tid
  %gep.out = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep.in
  %result = ashr i16 %a, 2
  store i16 %result, i16 addrspace(1)* %gep.out
  ret void
}

; GCN-LABEL: {{^}}s_ashr_4_i16:
; GCN-DAG: s_load_dword s[[HI:[0-9]+]], {{s\[[0-9]+:[0-9]+\]}}, {{0xc|0x30}}
; GCN: s_ashr_i16 s[[SHIFT:[0-9]+]], s[[HI]], 31
; GCN: s_mov_b32 s[[COPYSHIFT:[0-9]+]], s[[SHIFT]]
; GCN: s_add_u32 {{s[0-9]+}}, s[[HI]], {{s[0-9]+}}
; GCN: s_addc_u32 {{s[0-9]+}}, s[[COPYSHIFT]], {{s[0-9]+}}
define void @s_ashr_63_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) {
  %result = ashr i16 %a, 4
  %add = add i16 %result, %b
  store i16 %add, i16 addrspace(1)* %out
  ret void
}

; GCN-LABEL: {{^}}v_ashr_8_i16:
; VI: flat_load_dword v[[HI:[0-9]+]]
define void @v_ashr_63_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %in) {
  %tid = call i32 @llvm.r600.read.tidig.x() #0
  %gep.in = getelementptr i16, i16 addrspace(1)* %in, i32 %tid
  %gep.out = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep.in
  %result = ashr i16 %a, 8
  store i16 %result, i16 addrspace(1)* %gep.out
  ret void
}

attributes #0 = { nounwind readnone }
