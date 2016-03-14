; RUN: llc -march=amdgcn < %s | FileCheck -check-prefix=VI -check-prefix=FUNC %s

declare i32 @llvm.amdgcn.workitem.id.x() nounwind readnone

; FUNC-LABEL: {{^}}v_test_imin_sle_i16:
; VI: v_min_i16_e32
define void @v_test_imin_sle_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
	%tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
	%gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
	%gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
	%outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
	%a = load i16, i16 addrspace(1)* %gep0, align 4
	%b = load i16, i16 addrspace(1)* %gep1, align 4
	%cmp = icmp sle i16 %a, %b
	%val = select i1 %cmp, i16 %a, i16 %b
	store i16 %val, i16 addrspace(1)* %outgep, align 4
	ret void
}

; FUNC-LABEL: {{^}}s_test_imin_sle_i16:
; VI: s_min_i16
define void @s_test_imin_sle_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp sle i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: {{^}}s_test_imin_sle_v1i16:
; VI: s_min_i16
define void @s_test_imin_sle_v1i16(<1 x i16> addrspace(1)* %out, <1 x i16> %a, <1 x i16> %b) nounwind {
  %cmp = icmp sle <1 x i16> %a, %b
  %val = select <1 x i1> %cmp, <1 x i16> %a, <1 x i16> %b
  store <1 x i16> %val, <1 x i16> addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}s_test_imin_sle_v4i16:
; VI: v_min_i16
; VI: v_min_i16
; VI: v_min_i16
; VI: v_min_i16
define void @s_test_imin_sle_v4i16(<4 x i16> addrspace(1)* %out, <4 x i16> %a, <4 x i16> %b) nounwind {
  %cmp = icmp sle <4 x i16> %a, %b
  %val = select <4 x i1> %cmp, <4 x i16> %a, <4 x i16> %b
  store <4 x i16> %val, <4 x i16> addrspace(1)* %out
  ret void
}

; FUNC-LABEL: @v_test_imin_slt_i16
; VI: v_min_i16_e32
define void @v_test_imin_slt_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp slt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; FUNC-LABEL: @s_test_imin_slt_i16
; VI: s_min_i16
define void @s_test_imin_slt_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp slt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: {{^}}s_test_imin_slt_v2i16:
; VI: s_min_i16
; VI: s_min_i16
define void @s_test_imin_slt_v2i16(<2 x i16> addrspace(1)* %out, <2 x i16> %a, <2 x i16> %b) nounwind {
  %cmp = icmp slt <2 x i16> %a, %b
  %val = select <2 x i1> %cmp, <2 x i16> %a, <2 x i16> %b
  store <2 x i16> %val, <2 x i16> addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}s_test_imin_slt_imm_i16:
; VI: s_min_i16 {{s[0-9]+}}, {{s[0-9]+}}, 8
define void @s_test_imin_slt_imm_i16(i16 addrspace(1)* %out, i16 %a) nounwind {
  %cmp = icmp slt i16 %a, 8
  %val = select i1 %cmp, i16 %a, i16 8
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: {{^}}s_test_imin_sle_imm_i16:
; VI: s_min_i16 {{s[0-9]+}}, {{s[0-9]+}}, 8
define void @s_test_imin_sle_imm_i16(i16 addrspace(1)* %out, i16 %a) nounwind {
  %cmp = icmp sle i16 %a, 8
  %val = select i1 %cmp, i16 %a, i16 8
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @v_test_umin_ule_i16
; VI: v_min_u16_e32
define void @v_test_umin_ule_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp ule i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; FUNC-LABEL: @v_test_umin_ule_v3i16
; VI: v_min_u16_e32
; VI: v_min_u16_e32
; VI: v_min_u16_e32
; VI-NOT: v_min_u16_e32
; VI: s_endpgm
define void @v_test_umin_ule_v3i16(<3 x i16> addrspace(1)* %out, <3 x i16> %a, <3 x i16> %b) nounwind {
  %cmp = icmp ule <3 x i16> %a, %b
  %val = select <3 x i1> %cmp, <3 x i16> %a, <3 x i16> %b
  store <3 x i16> %val, <3 x i16> addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @s_test_umin_ule_i16
; VI: s_min_u16
define void @s_test_umin_ule_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp ule i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @v_test_umin_ult_i16
; VI: v_min_u16_e32
define void @v_test_umin_ult_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp ult i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; FUNC-LABEL: @s_test_umin_ult_i16
; VI: s_min_u16
define void @s_test_umin_ult_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp ult i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: @s_test_umin_ult_v1i16
; VI: s_min_u16
define void @s_test_umin_ult_v1i16(<1 x i16> addrspace(1)* %out, <1 x i16> %a, <1 x i16> %b) nounwind {
  %cmp = icmp ult <1 x i16> %a, %b
  %val = select <1 x i1> %cmp, <1 x i16> %a, <1 x i16> %b
  store <1 x i16> %val, <1 x i16> addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}s_test_umin_ult_v8i16:
; VI: s_min_u16
; VI: s_min_u16
; VI: s_min_u16
; VI: s_min_u16
; VI: s_min_u16
; VI: s_min_u16
; VI: s_min_u16
; VI: s_min_u16
define void @s_test_umin_ult_v8i16(<8 x i16> addrspace(1)* %out, <8 x i16> %a, <8 x i16> %b) nounwind {
  %cmp = icmp ult <8 x i16> %a, %b
  %val = select <8 x i1> %cmp, <8 x i16> %a, <8 x i16> %b
  store <8 x i16> %val, <8 x i16> addrspace(1)* %out
  ret void
}


