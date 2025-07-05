; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: The gc pointer parameter should be i8 addrspace(1)*
; CHECK-NEXT: %record addrspace(1)* %arg0
; CHECK-NEXT: in function foo1

define void @foo1(%record addrspace(1)* %arg0) #0 gc "cangjie" {
entry:
  %ret0 = alloca %record, align 8
  %0 = bitcast %record* %ret0 to i8*
  call void @llvm.cj.memset(i8* align 8 %0, i8 0, i64 16, i1 false)
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

declare void @llvm.cj.memset(i8*, i8, i64, i1) #10

attributes #0 = { "hasRcdParam" }
