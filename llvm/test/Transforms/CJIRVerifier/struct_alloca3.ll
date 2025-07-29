; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: Missing cj.memset in allocation of structure.
; CHECK-NEXT: %ret0 = alloca %record, align 8
; CHECK-NEXT: Bitcast struct* can only be callsite inst.
; CHECK-NEXT: %0 = bitcast %record* %ret0 to i8*
; CHECK-NEXT: in function foo2

define void @foo2() #0 gc "cangjie" {
entry:
  %ret0 = alloca %record, align 8
  %0 = bitcast %record* %ret0 to i8*
  store i8 20, i8* %0, align 8
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

attributes #0 = { "hasRcdParam" }
