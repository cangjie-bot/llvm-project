; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: Alloca struct* should only be used for dbg.declare
; CHECK-NEXT: %ret0 = alloca %record*, align 8
; CHECK-NEXT: in function foo

define void @foo() #0 gc "cangjie" {
entry:
  %ret0 = alloca %record*, align 8
  %0 = bitcast %record** %ret0 to i8**
  %ret1 = alloca %record**, align 8
  %1 = bitcast %record*** %ret1 to i8***
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

attributes #0 = { "hasRcdParam" }
