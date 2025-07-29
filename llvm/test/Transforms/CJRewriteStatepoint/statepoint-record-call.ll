; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record = type { i64, i8 addrspace(1)* }

declare void @g() #0 gc "cangjie"

define %record @foo1(%record %arg) #0 gc "cangjie" {
; CHECK-LABEL: @foo1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @g, i32 0, i32 0) [ "gc-live"(%record [[ARG:%.*]]) ]
;
entry:
  call void @g()
  ret %record %arg
}

define %record addrspace(1)* @foo2(%record addrspace(1)* %arg1, i8 addrspace(1)* %arg0) #0 gc "cangjie" {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @g, i32 0, i32 0) [ "gc-live"(%record addrspace(1)* [[ARG1:%.*]], i8 addrspace(1)* [[ARG0:%.*]]) ]
; CHECK-NEXT:    [[ARG1_RELOC:%.*]] = call coldcc i8 addrspace(1)* @llvm.cj.gc.relocate.p1i8(token [[TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[ARG1_RELOC_CASTED:%.*]] = bitcast i8 addrspace(1)* [[ARG1_RELOC]] to %record addrspace(1)*
; CHECK-NEXT:    [[ARG0_RELOC:%.*]] = call coldcc i8 addrspace(1)* @llvm.cj.gc.relocate.p1i8(token [[TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret %record addrspace(1)* [[ARG1_RELOC_CASTED]]
;
entry:
  call void @g()
  ret %record addrspace(1)* %arg1
}

attributes #0 = { "record_mut" }
