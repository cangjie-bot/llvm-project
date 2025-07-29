; RUN: opt -enable-new-pm=false -cj-loop-float-opt -S < %s | FileCheck %s
; RUN: opt -passes=cj-loop-float-opt -S < %s | FileCheck %s


declare void @"CJ_MCC_ThrowException"() gc "cangjie"

declare void @"CJ_MCC_ThrowArithmeticException"() gc "cangjie"

declare i64 @llvm.cj.get.fp.state.i64(i64)

define void @"foo"() gc "cangjie" {
bb6:
  br label %bb11
; CHECK:       %.0612 = phi i64 [ 0, %bb6 ], [ %and1, %divEnd ]
; CHECK:       br label %normal1
bb11:                                             ; preds = %bb6, %divEnd
  %f3.013 = phi double [ 1.000000e+00, %bb6 ], [ %f3.1, %divEnd ]
  %.0612 = phi i64 [ 0, %bb6 ], [ %and1, %divEnd ]
  %and1 = add nuw nsw i64 %.0612, 1
  %fptosi1 = fptosi double %f3.013 to i64
  %fpstate1 = tail call i64 @llvm.cj.get.fp.state.i64(i64 %fptosi1)
  %and2 = and i64 %fpstate1, 1
  %cmp1 = icmp eq i64 %and2, 0
  br i1 %cmp1, label %normal1, label %fp.convert.exception

fp.convert.exception:                             ; preds = %bb11
  %bc1 = bitcast double %f3.013 to i64
  %and3 = and i64 %bc1, 9218868437227405312
  %notInfOrNan.not = icmp eq i64 %and3, 9218868437227405312
  br i1 %notInfOrNan.not, label %inf.or.nan, label %not.inf.nan

not.inf.nan:                                      ; preds = %fp.convert.exception
  %f2i.lt.min = fcmp ogt double %f3.013, 0xC3E0000000000001
  br i1 %f2i.lt.min, label %lower.bound.ok, label %lower.bound.overflow

lower.bound.ok:                                   ; preds = %not.inf.nan
  %f2i.gt.max = fcmp olt double %f3.013, 0x43E0000000000000
  br i1 %f2i.gt.max, label %normal1, label %upper.bound.overflow

upper.bound.overflow:                             ; preds = %lower.bound.ok
  tail call void @CJ_MCC_ThrowException()
  unreachable

lower.bound.overflow:                             ; preds = %not.inf.nan
  tail call void @CJ_MCC_ThrowException()
  unreachable

inf.or.nan:                                       ; preds = %fp.convert.exception
  tail call void @CJ_MCC_ThrowException()
  unreachable

normal1:                                          ; preds = %bb11, %lower.bound.ok
  %divisor_is_0 = icmp eq i64 %fptosi1, 0
  br i1 %divisor_is_0, label %div.divisorIs0, label %divEnd

div.divisorIs0:                                   ; preds = %normal1
  tail call void @CJ_MCC_ThrowArithmeticException()
  unreachable

; CHECK:       %1 = select i1 %icmpeq, i64 1, i64 2
; CHECK-NEXT:  add i64 %0, %1
divEnd:                                           ; preds = %normal1
  %icmpeq = icmp eq i64 %fptosi1, 0
  %f3.1.v = select i1 %icmpeq, double 1.000000e+00, double 2.000000e+00
  %f3.1 = fadd double %f3.013, %f3.1.v
  %exitcond.not = icmp eq i64 %and1, 3000000
  br i1 %exitcond.not, label %bb10, label %bb11

bb10:                                             ; preds = %divEnd
  ret void
}
