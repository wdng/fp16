; RUN: llc < %s -march=amdgcn -mcpu=fiji -verify-machineinstrs | FileCheck -check-prefix=GCN -check-prefix=VI %s


declare i32 @llvm.amdgcn.workitem.id.x() nounwind readnone

; GCN-LABEL: {{^}}v_test_imax_sge_i16:
; VI: v_max_i16_e32 v{{[0-9]+}}, v{{[0-9]+}}, v{{[0-9]+}}
define void @v_test_imax_sge_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp sge i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}v_test_imax_sge_v4i16:
; VI: v_max_i16_e32 v{{[0-9]+}}, v{{[0-9]+}}, v{{[0-9]+}}
; VI: v_max_i16_e32 v{{[0-9]+}}, v{{[0-9]+}}, v{{[0-9]+}}
; VI: v_max_i16_e32 v{{[0-9]+}}, v{{[0-9]+}}, v{{[0-9]+}}
; VI: v_max_i16_e32 v{{[0-9]+}}, v{{[0-9]+}}, v{{[0-9]+}}
define void @v_test_imax_sge_v4i16(<4 x i16> addrspace(1)* %out, <4 x i16> addrspace(1)* %aptr, <4 x i16> addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %out, i32 %tid
  %a = load <4 x i16>, <4 x i16> addrspace(1)* %gep0, align 4
  %b = load <4 x i16>, <4 x i16> addrspace(1)* %gep1, align 4
  %cmp = icmp sge <4 x i16> %a, %b
  %val = select <4 x i1> %cmp, <4 x i16> %a, <4 x i16> %b
  store <4 x i16> %val, <4 x i16> addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_imax_sge_i16:
; VI: v_max_i16_e32
define void @s_test_imax_sge_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp sge i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_imax_sge_imm_i16:
; VI: v_max_i16_e32 {{v[0-9]+}},  9, {{v[0-9]+}}

define void @s_test_imax_sge_imm_i16(i16 addrspace(1)* %out, i16 %a) nounwind {
  %cmp = icmp sge i16 %a, 9
  %val = select i1 %cmp, i16 %a, i16 9
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_imax_sgt_imm_i16:
; VI: v_max_i16_e32 {{v[0-9]+}},  9, {{v[0-9]+}}
define void @s_test_imax_sgt_imm_i16(i16 addrspace(1)* %out, i16 %a) nounwind {
  %cmp = icmp sgt i16 %a, 9
  %val = select i1 %cmp, i16 %a, i16 9
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_imax_sgt_imm_v2i16:
; VI: v_max_i16_e32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
; VI: v_max_i16_e32 {{v[0-9]+}},  9, {{v[0-9]+}}
define void @s_test_imax_sgt_imm_v2i16(<2 x i16> addrspace(1)* %out, <2 x i16> %a) nounwind {
  %cmp = icmp sgt <2 x i16> %a, <i16 9, i16 9>
  %val = select <2 x i1> %cmp, <2 x i16> %a, <2 x i16> <i16 9, i16 9>
  store <2 x i16> %val, <2 x i16> addrspace(1)* %out, align 4
  ret void
}
; GCN-LABEL: {{^}}v_test_imax_sgt_i16:
; VI: v_max_i16_e32
define void @v_test_imax_sgt_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp sgt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_imax_sgt_i16:
; VI: v_max_i16_e32
define void @s_test_imax_sgt_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp sgt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}v_test_umax_uge_i16:
; VI: v_max_u16_e32
define void @v_test_umax_uge_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp uge i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_umax_uge_i16:
; VI: v_max_u16_e32
define void @s_test_umax_uge_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp uge i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_umax_uge_v3i16:
; VI: v_max_u16_e32
; VI: v_max_u16_e32
; VI: v_max_u16_e32
; VI-NOT: v_max_u16_e32
; VI: s_endpgm
define void @s_test_umax_uge_v3i16(<3 x i16> addrspace(1)* %out, <3 x i16> %a, <3 x i16> %b) nounwind {
  %cmp = icmp uge <3 x i16> %a, %b
  %val = select <3 x i1> %cmp, <3 x i16> %a, <3 x i16> %b
  store <3 x i16> %val, <3 x i16> addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}v_test_umax_ugt_i16:
; VI: v_max_u16_e32
define void @v_test_umax_ugt_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp ugt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_umax_ugt_i16:
; VI: v_max_u16_e32
define void @s_test_umax_ugt_i16(i16 addrspace(1)* %out, i16 %a, i16 %b) nounwind {
  %cmp = icmp ugt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}s_test_umax_ugt_imm_v2i16:
; VI-DAG: v_max_u16_e32 {{v[0-9]+}}, 23, {{v[0-9]+}}
; VI-DAG: v_max_u16_e32 {{v[0-9]+}}, 15, {{v[0-9]+}}
define void @s_test_umax_ugt_imm_v2i16(<2 x i16> addrspace(1)* %out, <2 x i16> %a) nounwind {
  %cmp = icmp ugt <2 x i16> %a, <i16 15, i16 23>
  %val = select <2 x i1> %cmp, <2 x i16> %a, <2 x i16> <i16 15, i16 23>
  store <2 x i16> %val, <2 x i16> addrspace(1)* %out, align 4
  ret void
}

