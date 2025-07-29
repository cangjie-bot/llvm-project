; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record = type { i64, i8 addrspace(1)* }

declare void @g() #0 gc "cangjie"

define %record @foo1(%record %arg) #0 gc "cangjie" personality i32 8  {
; CHECK-LABEL: @foo1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOKEN:%.*]] = invoke token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @g, i32 0, i32 0) [ "gc-live"(%record [[ARG:%.*]]) ]
; CHECK-NEXT:    to label [[NORMAL_DEST:%.*]] unwind label [[UNWIND_DEST:%.*]]
; CHECK:       normal_dest:
; CHECK-NEXT:    ret %record [[ARG:%.*]]
; CHECK:       unwind_dest:
; CHECK-NEXT:    [[LPAD:%.*]] = landingpad token
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    resume token undef
;
entry:
  invoke void @g() to label %normal_dest unwind label %unwind_dest

normal_dest:
  ret %record %arg

unwind_dest:
  %lpad = landingpad token cleanup
  resume token undef
}

define %record addrspace(1)* @foo2(%record addrspace(1)* %arg1, i8 addrspace(1)* %arg0) #0 gc "cangjie" personality i32 8  {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOKEN:%.*]] = invoke token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @g, i32 0, i32 0) [ "gc-live"(%record addrspace(1)* [[ARG1:%.*]], i8 addrspace(1)* [[ARG0:%.*]]) ]
; CHECK-NEXT:    to label [[NORMAL_DEST:%.*]] unwind label [[UNWIND_DEST:%.*]]
; CHECK:       normal_dest:
; CHECK-NEXT:    [[ARG1_RELOC1:%.*]] = call coldcc i8 addrspace(1)* @llvm.cj.gc.relocate.p1i8(token [[TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[ARG1_RELOC1_CASTED:%.*]] = bitcast i8 addrspace(1)* [[ARG1_RELOC1]] to %record addrspace(1)*
; CHECK-NEXT:    [[ARG0_RELOC2:%.*]] = call coldcc i8 addrspace(1)* @llvm.cj.gc.relocate.p1i8(token [[TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret %record addrspace(1)* [[ARG1_RELOC1_CASTED]]
; CHECK:       unwind_dest:
; CHECK-NEXT:    [[LPAD:%.*]] = landingpad token
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    [[ARG1_RELOC:%.*]] = call coldcc i8 addrspace(1)* @llvm.cj.gc.relocate.p1i8(token [[LPAD]], i32 1, i32 0)
; CHECK-NEXT:    [[ARG1_RELOC_CASTED:%.*]] = bitcast i8 addrspace(1)* [[ARG1_RELOC]] to %record addrspace(1)*
; CHECK-NEXT:    [[ARG0_RELOC:%.*]] = call coldcc i8 addrspace(1)* @llvm.cj.gc.relocate.p1i8(token [[LPAD]], i32 1, i32 1)
; CHECK-NEXT:    resume token undef
;
entry:
  invoke void @g() to label %normal_dest unwind label %unwind_dest

normal_dest:
  ret %record addrspace(1)* %arg1
unwind_dest:
  %lpad = landingpad token cleanup
  resume token undef
}

attributes #0 = { "record_mut" }
