; RUN: llc --cangjie-pipeline -mtriple=aarch64 < %s | FileCheck %s
; XFAIL: *

define internal void @func_atomic_store(i8 addrspace(1)* %this, i8 addrspace(1)* %that) gc "cangjie"  {
entry:
; CHECK: func_atomic_store
; CHECK: lsr     w9, x28, #56
; CHECK: cmp     w9, #9
; CHECK: gcNoRunning
; CHECK: stlr    x0, [x1]
; CHECK: gcRunning
; CHECK: bl      CJ_MCC_AtomicWriteReference

  %0 = bitcast i8 addrspace(1)* %that to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.atomic.store(i8 addrspace(1)* %this, i8 addrspace(1)* %that, i8 addrspace(1)* addrspace(1)* %0, i32 5)
  ret void
}

define internal void @func_atomic_compare_swap(i8 addrspace(1)* %this, i8 addrspace(1)* %that) gc "cangjie" {
entry:
; CHECK: func_atomic_compare_swap
; CHECK: lsr     w9, x28, #56
; CHECK: cmp     w9, #9
; CHECK: gcRunning
; CHECK: bl      CJ_MCC_CompareAndSwapReference

  %0 = bitcast i8 addrspace(1)* %that to i8 addrspace(1)* addrspace(1)*
  %1 = call i1 @llvm.cj.atomic.compare.swap(i8 addrspace(1)* %this, i8 addrspace(1)* %that, i8 addrspace(1)* %this, i8 addrspace(1)* addrspace(1)* %0, i32 5, i32 5)
  ret void
}

define internal void @func_atomic_swap(i8 addrspace(1)* %this, i8 addrspace(1)* %that) gc "cangjie" {
entry:
; CHECK: func_atomic_swap
; CHECK: lsr     w9, x28, #56
; CHECK: cmp     w9, #9
; CHECK: gcRunning
; CHECK: bl      CJ_MCC_AtomicSwapReference

  %0 = bitcast i8 addrspace(1)* %that to i8 addrspace(1)* addrspace(1)*
  %1 = call i8 addrspace(1)* @llvm.cj.atomic.swap(i8 addrspace(1)* %this, i8 addrspace(1)* %that, i8 addrspace(1)* addrspace(1)* %0, i32 5)
  ret void
}

; Function Attrs: nounwind
declare void @llvm.cj.atomic.store(i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*, i32)

; Function Attrs: nounwind
declare i8 addrspace(1)* @llvm.cj.atomic.swap(i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*, i32)

; Function Attrs: nounwind
declare i1 @llvm.cj.atomic.compare.swap(i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*, i32, i32)
