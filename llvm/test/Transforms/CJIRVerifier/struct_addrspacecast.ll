; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: Addrspacecast result can only be used for store or call.
; CHECK-NEXT: %0 = addrspacecast %record* %callRet to %record addrspace(1)*
; CHECK-NEXT: in function foo

define void @foo(%record* noalias sret(%record) %callRet) #0 gc "cangjie" {
entry:
  %0 = addrspacecast %record* %callRet to %record addrspace(1)*
  %1 = bitcast %record addrspace(1)* %0 to i8 addrspace(1)*
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

attributes #0 = { "hasRcdParam" }
