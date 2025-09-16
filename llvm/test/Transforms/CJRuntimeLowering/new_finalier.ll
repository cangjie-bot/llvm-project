; RUN: opt < %s -passes=cj-runtime-lowering -S | FileCheck %s
%TypeInfo = type { i8*, i8, i8, i16, i32, i8*, i32, i8, i8, i32*, i8*, i8*, i8*, i8*, i8*, i8* }

declare i8 addrspace(1)* @llvm.cj.malloc.object(i8*, i32)

; NewFinalier cannot add "cj-malloc" attribute, because it may call a finalier method when destructor performing.

define void @lower_new_finalier(i8* %ti, i8** %s) {
; CHECK-LABEL: @lower_new_finalier(
; CHECK:    declare i8 addrspace(1)* @CJ_MCC_NewFinalizer(i8*, i32) #1
; CHECK:    attributes #1 = { "cj-runtime" }
;
  %obj = call noalias i8 addrspace(1)* @llvm.cj.malloc.object(i8* %ti, i32 32), !MallocType !0
  ret void
}

!0 = !{!"HasFinalizer"}
