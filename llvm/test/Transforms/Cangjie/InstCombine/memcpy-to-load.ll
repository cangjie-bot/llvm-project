; RUN: opt < %s -passes=instcombine -S | FileCheck %s

%record = type { i1 }

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1) nounwind

; memcpy can be expanded inline with load/store (based on the datalayout?)

define void @copy_1_byte(%record* %d, i8** %s) {
; CHECK-LABEL: @copy_1_byte(
; CHECK:    [[TMP1:%.*]] = load i8, i8* [[S:%.*]], align 1
; CHECK:    store i8 [[TMP1]], i8* [[D:%.*]], align 1
;
  %s.i = bitcast i8** %s to i8***
  %s.ii = load i8**, i8*** %s.i
  %s.iii = bitcast i8** %s.ii to i8*
  %d.i = bitcast %record* %d to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %d.i, i8* %s.iii, i32 1, i1 false)
  ret void
}