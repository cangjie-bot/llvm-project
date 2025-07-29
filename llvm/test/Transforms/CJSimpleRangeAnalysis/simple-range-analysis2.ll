; RUN: opt -cj-simple-range-analysis -instcombine -simplifycfg -gvn -S < %s | FileCheck %s

; CHECK: bb2.i.i:
; CHECK-NEXT: %7 = fadd double %n, -5.000000e+00
; CHECK-NEXT: %8 = call fastcc i64 @_ZN7default3fibEd(double %7)
; CHECK-NEXT: %9 = add i64 %8, %2
; CHECK-NEXT: br label %_ZN7default3fibEd.exit.i
define internal fastcc i64 @_ZN7default3fibEd(double %n) #0 {
bb0:
  %fcmpolt = fcmp olt double %n, 2.000000e+00
  br i1 %fcmpolt, label %common.ret, label %bb2

common.ret:                                       ; preds = %bb0, %_ZN7default3fibEd.exit5
  %common.ret.op = phi i64 [ %16, %_ZN7default3fibEd.exit5 ], [ 1, %bb0 ]
  ret i64 %common.ret.op

bb2:                                              ; preds = %bb0
  %0 = fadd double %n, -2.000000e+00
  %fcmpolt.i = fcmp olt double %0, 2.000000e+00
  br i1 %fcmpolt.i, label %_ZN7default3fibEd.exit, label %bb2.i

bb2.i:                                            ; preds = %bb2
  %1 = fadd double %0, -2.000000e+00
  %2 = call fastcc i64 @_ZN7default3fibEd(double %1)
  %3 = fadd double %0, -1.000000e+00
  %4 = call fastcc i64 @_ZN7default3fibEd(double %3)
  %5 = add i64 %2, %4
  br label %_ZN7default3fibEd.exit

_ZN7default3fibEd.exit:                           ; preds = %bb2, %bb2.i
  %common.ret.op.i = phi i64 [ %5, %bb2.i ], [ 1, %bb2 ]
  %6 = fadd double %n, -1.000000e+00
  %fcmpolt.i2 = fcmp olt double %6, 2.000000e+00
  br i1 %fcmpolt.i2, label %_ZN7default3fibEd.exit5, label %bb2.i4

bb2.i4:                                           ; preds = %_ZN7default3fibEd.exit
  %7 = fadd double %6, -2.000000e+00
  %fcmpolt.i.i = fcmp olt double %7, 2.000000e+00
  br i1 %fcmpolt.i.i, label %_ZN7default3fibEd.exit.i, label %bb2.i.i

bb2.i.i:                                          ; preds = %bb2.i4
  %8 = fadd double %7, -2.000000e+00
  %9 = call fastcc i64 @_ZN7default3fibEd(double %8)
  %10 = fadd double %7, -1.000000e+00
  %11 = call fastcc i64 @_ZN7default3fibEd(double %10)
  %12 = add i64 %9, %11
  br label %_ZN7default3fibEd.exit.i

_ZN7default3fibEd.exit.i:                         ; preds = %bb2.i.i, %bb2.i4
  %common.ret.op.i.i = phi i64 [ %12, %bb2.i.i ], [ 1, %bb2.i4 ]
  %13 = fadd double %6, -1.000000e+00
  %14 = call fastcc i64 @_ZN7default3fibEd(double %13)
  %15 = add i64 %common.ret.op.i.i, %14
  br label %_ZN7default3fibEd.exit5

_ZN7default3fibEd.exit5:                          ; preds = %_ZN7default3fibEd.exit, %_ZN7default3fibEd.exit.i
  %common.ret.op.i3 = phi i64 [ %15, %_ZN7default3fibEd.exit.i ], [ 1, %_ZN7default3fibEd.exit ]
  %16 = add i64 %common.ret.op.i, %common.ret.op.i3
  br label %common.ret
}

attributes #0 = { nofree nosync nounwind readnone willreturn}