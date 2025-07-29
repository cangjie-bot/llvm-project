; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: The gc pointer parameter should be i8 addrspace(1)*
; CHECK-NEXT: %record addrspace(1)* %arg0
; CHECK-NEXT: Missing cj.memset in allocation of structure.
; CHECK-NEXT: %ret0 = alloca %record, align 8
; CHECK-NEXT: in function foo2

define void @foo2(%record addrspace(1)* %arg0, i8 addrspace(1)* %bp) gc "cangjie" {
entry:
  %ret0 = alloca %record, align 8
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

declare void @llvm.cj.memset(i8*, i8, i64, i1)
