; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: sret is not on the first parameter!
; CHECK-NEXT: %record* %callRet
; CHECK-NEXT: in function foo

define void @foo(i8 addrspace(1)* %ref, %record* noalias sret(%record) %callRet) #0 gc "cangjie" {
entry:
  %retVal = alloca i64, align 8
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

attributes #0 = { "hasRcdParam" }
