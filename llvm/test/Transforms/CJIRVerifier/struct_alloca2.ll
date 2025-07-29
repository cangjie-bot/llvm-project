; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: Alloca %struct addrspace(1)* is not allowed.
; CHECK-NEXT: %temp0 = alloca %record addrspace(1)*, align 8
; CHECK-NEXT: Alloca addrspace(1)** is not allowed.
; CHECK-NEXT: %temp1 = alloca %record addrspace(1)**, align 8
; CHECK-NEXT: in function foo1

define void @foo1(i8 addrspace(1)* %bp, %record addrspace(1)* %arg0) #0 gc "cangjie" {
entry:
  %temp0 = alloca %record addrspace(1)*
  store %record addrspace(1)* %arg0, %record addrspace(1)** %temp0
  %temp1 = alloca %record addrspace(1)**
  store %record addrspace(1)** %temp0, %record addrspace(1)*** %temp1
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

attributes #0 = { "hasRcdParam" }
