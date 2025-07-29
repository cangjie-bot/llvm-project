; RUN: llc --cangjie-pipeline -mtriple=x86_64 < %s | FileCheck %s
; XFAIL: *

define internal void @func_atomic_store(i8 addrspace(1)* %this, i8 addrspace(1)* %that) gc "cangjie"  {
entry:
; CHECK: func_atomic_store
; CHECK: movq    8(%r15), %rax
; CHECK: movl    (%rax), %eax
; CHECK: cmpl    $9, %eax
; CHECK: gcNoRunning
; CHECK: xchgq   %rdi, (%rsi)
; CHECK: gcRunning
; CHECK: callq   CJ_MCC_AtomicWriteReference@PLT

  %0 = bitcast i8 addrspace(1)* %that to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.atomic.store(i8 addrspace(1)* %this, i8 addrspace(1)* %that, i8 addrspace(1)* addrspace(1)* %0, i32 5)
  ret void
}

define internal void @func_atomic_compare_swap(i8 addrspace(1)* %this, i8 addrspace(1)* %that) gc "cangjie" {
entry:
; CHECK: func_atomic_compare_swap
; CHECK: movq    8(%r15), %rax
; CHECK: movl    (%rax), %eax
; CHECK: cmpl    $9, %eax
; CHECK: gcNoRunning
; CHECK: lock            cmpxchgq        %rsi, (%rsi)
; CHECK: gcRunning
; CHECK: callq   CJ_MCC_CompareAndSwapReference@PLT

  %0 = bitcast i8 addrspace(1)* %that to i8 addrspace(1)* addrspace(1)*
  %1 = call i1 @llvm.cj.atomic.compare.swap(i8 addrspace(1)* %this, i8 addrspace(1)* %that, i8 addrspace(1)* %this, i8 addrspace(1)* addrspace(1)* %0, i32 5, i32 5)
  ret void
}

define internal void @func_atomic_swap(i8 addrspace(1)* %this, i8 addrspace(1)* %that) gc "cangjie" {
entry:
; CHECK: func_atomic_swap
; CHECK: movq    8(%r15), %rax
; CHECK: movl    (%rax), %eax
; CHECK: cmpl    $9, %eax
; CHECK: gcNoRunning
; CHECK: xchgq   %rdi, (%rsi)
; CHECK: gcRunning
; CHECK: callq   CJ_MCC_AtomicSwapReference@PLT

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
