; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck -check-prefix=SI %s
; RUN: llc -march=amdgcn -mcpu=tonga -verify-machineinstrs < %s | FileCheck -check-prefix=SI %s

; SI-LABEL: {{^}}s_sext_i1_to_i32:
; SI: v_cndmask_b32_e64
; SI: s_endpgm
define void @s_sext_i1_to_i32(i32 addrspace(1)* %out, i32 %a, i32 %b) nounwind {
  %cmp = icmp eq i32 %a, %b
  %sext = sext i1 %cmp to i32
  store i32 %sext, i32 addrspace(1)* %out, align 4
  ret void
}

; SI-LABEL: {{^}}test_s_sext_i32_to_i64:
; SI: s_ashr_i32
; SI: s_endpg
define void @test_s_sext_i32_to_i64(i64 addrspace(1)* %out, i32 %a, i32 %b, i32 %c) nounwind {
entry:
  %mul = mul i32 %a, %b
  %add = add i32 %mul, %c
  %sext = sext i32 %add to i64
  store i64 %sext, i64 addrspace(1)* %out, align 8
  ret void
}

; SI-LABEL: {{^}}s_sext_i1_to_i64:
; SI: v_cndmask_b32_e64 v[[LOREG:[0-9]+]], 0, -1, vcc
; SI: v_mov_b32_e32 v[[HIREG:[0-9]+]], v[[LOREG]]
; SI: buffer_store_dwordx2 v{{\[}}[[LOREG]]:[[HIREG]]{{\]}}
; SI: s_endpgm
define void @s_sext_i1_to_i64(i64 addrspace(1)* %out, i32 %a, i32 %b) nounwind {
  %cmp = icmp eq i32 %a, %b
  %sext = sext i1 %cmp to i64
  store i64 %sext, i64 addrspace(1)* %out, align 8
  ret void
}

; SI-LABEL: {{^}}s_sext_i32_to_i64:
; SI: s_ashr_i32
; SI: s_endpgm
define void @s_sext_i32_to_i64(i64 addrspace(1)* %out, i32 %a) nounwind {
  %sext = sext i32 %a to i64
  store i64 %sext, i64 addrspace(1)* %out, align 8
  ret void
}

; SI-LABEL: {{^}}v_sext_i32_to_i64:
; SI: v_ashr
; SI: s_endpgm
define void @v_sext_i32_to_i64(i64 addrspace(1)* %out, i32 addrspace(1)* %in) nounwind {
  %val = load i32, i32 addrspace(1)* %in, align 4
  %sext = sext i32 %val to i64
  store i64 %sext, i64 addrspace(1)* %out, align 8
  ret void
}

; SI-LABEL: {{^}}s_sext_i16_to_i64:
; SI: s_bfe_i64 s{{\[[0-9]+:[0-9]+\]}}, s{{\[[0-9]+:[0-9]+\]}}, 0x100000
define void @s_sext_i16_to_i64(i64 addrspace(1)* %out, i16 %a) nounwind {
  %sext = sext i16 %a to i64
  store i64 %sext, i64 addrspace(1)* %out, align 8
  ret void
}

; SI-LABEL: {{^}}s_sext_i1_to_i16:
; SI: v_cndmask_b32_e64 [[RESULT:v[0-9]+]], 0, -1
; SI-NEXT: buffer_store_short [[RESULT]]
define void @s_sext_i1_to_i16(i16 addrspace(1)* %out, i32 %a, i32 %b) nounwind {
  %cmp = icmp eq i32 %a, %b
  %sext = sext i1 %cmp to i16
  store i16 %sext, i16 addrspace(1)* %out
  ret void
}

; GCN-LABEL: {{^}}s_sext_v4i8_to_v4i32:
; GCN: s_load_dword [[VAL:s[0-9]+]]
; GCN-DAG: s_sext_i32_i8 [[EXT0:s[0-9]+]], [[VAL]]
; GCN-DAG: s_bfe_i32 [[EXT1:s[0-9]+]], [[VAL]], 0x80008
; GCN-DAG: s_bfe_i32 [[EXT2:s[0-9]+]], [[VAL]], 0x80010
; GCN-DAG: s_ashr_i32 [[EXT3:s[0-9]+]], [[VAL]], 24

; GCN-DAG: v_mov_b32_e32 [[VEXT0:v[0-9]+]], [[EXT0]]
; GCN-DAG: v_mov_b32_e32 [[VEXT1:v[0-9]+]], [[EXT1]]
; GCN-DAG: v_mov_b32_e32 [[VEXT2:v[0-9]+]], [[EXT2]]
; GCN-DAG: v_mov_b32_e32 [[VEXT3:v[0-9]+]], [[EXT3]]

; GCN-DAG: buffer_store_dword [[VEXT0]]
; GCN-DAG: buffer_store_dword [[VEXT1]]
; GCN-DAG: buffer_store_dword [[VEXT2]]
; GCN-DAG: buffer_store_dword [[VEXT3]]

; GCN: s_endpgm
define void @s_sext_v4i8_to_v4i32(i32 addrspace(1)* %out, i32 %a) nounwind {
  %cast = bitcast i32 %a to <4 x i8>
  %ext = sext <4 x i8> %cast to <4 x i32>
  %elt0 = extractelement <4 x i32> %ext, i32 0
  %elt1 = extractelement <4 x i32> %ext, i32 1
  %elt2 = extractelement <4 x i32> %ext, i32 2
  %elt3 = extractelement <4 x i32> %ext, i32 3
  store volatile i32 %elt0, i32 addrspace(1)* %out
  store volatile i32 %elt1, i32 addrspace(1)* %out
  store volatile i32 %elt2, i32 addrspace(1)* %out
  store volatile i32 %elt3, i32 addrspace(1)* %out
  ret void
}

; GCN-LABEL: {{^}}v_sext_v4i8_to_v4i32:
; GCN: buffer_load_dword [[VAL:v[0-9]+]]
; GCN-DAG: v_bfe_i32 [[EXT0:v[0-9]+]], [[VAL]], 0, 8
; GCN-DAG: v_bfe_i32 [[EXT1:v[0-9]+]], [[VAL]], 8, 8
; GCN-DAG: v_bfe_i32 [[EXT2:v[0-9]+]], [[VAL]], 16, 8
; GCN-DAG: v_ashrrev_i32_e32 [[EXT3:v[0-9]+]], 24, [[VAL]]

; GCN: buffer_store_dword [[EXT0]]
; GCN: buffer_store_dword [[EXT1]]
; GCN: buffer_store_dword [[EXT2]]
; GCN: buffer_store_dword [[EXT3]]
define void @v_sext_v4i8_to_v4i32(i32 addrspace(1)* %out, i32 addrspace(1)* %in) nounwind {
  %a = load i32, i32 addrspace(1)* %in
  %cast = bitcast i32 %a to <4 x i8>
  %ext = sext <4 x i8> %cast to <4 x i32>
  %elt0 = extractelement <4 x i32> %ext, i32 0
  %elt1 = extractelement <4 x i32> %ext, i32 1
  %elt2 = extractelement <4 x i32> %ext, i32 2
  %elt3 = extractelement <4 x i32> %ext, i32 3
  store volatile i32 %elt0, i32 addrspace(1)* %out
  store volatile i32 %elt1, i32 addrspace(1)* %out
  store volatile i32 %elt2, i32 addrspace(1)* %out
  store volatile i32 %elt3, i32 addrspace(1)* %out
  ret void
}

; FIXME: s_bfe_i64
; GCN-LABEL: {{^}}s_sext_v4i16_to_v4i32:
; GCN-DAG: s_ashr_i64 s{{\[[0-9]+:[0-9]+\]}}, s{{\[[0-9]+:[0-9]+\]}}, 48
; GCN-DAG: s_ashr_i32 s{{[0-9]+}}, s{{[0-9]+}}, 16
; GCN-DAG: s_sext_i32_i16
; GCN-DAG: s_sext_i32_i16
; GCN: s_endpgm
define void @s_sext_v4i16_to_v4i32(i32 addrspace(1)* %out, i64 %a) nounwind {
  %cast = bitcast i64 %a to <4 x i16>
  %ext = sext <4 x i16> %cast to <4 x i32>
  %elt0 = extractelement <4 x i32> %ext, i32 0
  %elt1 = extractelement <4 x i32> %ext, i32 1
  %elt2 = extractelement <4 x i32> %ext, i32 2
  %elt3 = extractelement <4 x i32> %ext, i32 3
  store volatile i32 %elt0, i32 addrspace(1)* %out
  store volatile i32 %elt1, i32 addrspace(1)* %out
  store volatile i32 %elt2, i32 addrspace(1)* %out
  store volatile i32 %elt3, i32 addrspace(1)* %out
  ret void
}

; GCN-LABEL: {{^}}v_sext_v4i16_to_v4i32:
; SI-DAG: v_ashr_i64 v{{\[[0-9]+:[0-9]+\]}}, v{{\[[0-9]+:[0-9]+\]}}, 48
; VI-DAG: v_ashrrev_i64 v{{\[[0-9]+:[0-9]+\]}}, 48, v{{\[[0-9]+:[0-9]+\]}}
; GCN-DAG: v_ashrrev_i32_e32 v{{[0-9]+}}, 16, v{{[0-9]+}}
; GCN-DAG: v_ashrrev_i32_e32 v{{[0-9]+}}, 16, v{{[0-9]+}}
; GCN-DAG: v_bfe_i32 v{{[0-9]+}}, v{{[0-9]+}}, 0, 16
; GCN-DAG: v_bfe_i32 v{{[0-9]+}}, v{{[0-9]+}}, 0, 16
; GCN: s_endpgm
define void @v_sext_v4i16_to_v4i32(i32 addrspace(1)* %out, i64 addrspace(1)* %in) nounwind {
  %a = load i64, i64 addrspace(1)* %in
  %cast = bitcast i64 %a to <4 x i16>
  %ext = sext <4 x i16> %cast to <4 x i32>
  %elt0 = extractelement <4 x i32> %ext, i32 0
  %elt1 = extractelement <4 x i32> %ext, i32 1
  %elt2 = extractelement <4 x i32> %ext, i32 2
  %elt3 = extractelement <4 x i32> %ext, i32 3
  store volatile i32 %elt0, i32 addrspace(1)* %out
  store volatile i32 %elt1, i32 addrspace(1)* %out
  store volatile i32 %elt2, i32 addrspace(1)* %out
  store volatile i32 %elt3, i32 addrspace(1)* %out
  ret void
}
