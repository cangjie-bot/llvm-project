; RUN: opt -cj-loop-float-opt -S < %s | FileCheck %s
; RUN: opt -passes=cj-loop-float-opt -S < %s | FileCheck %s

declare void @"_ZN8std$core7printlnEd"(double) gc "cangjie"

define void @"foo"() gc "cangjie" {
bb59:
  br label %bb64
bb64:                                             ; preds = %bb59, %bb64
  %0 = phi i64 [ 0, %bb59 ], [ %1, %bb64 ]
  %f3.04 = phi double [ 1.000000e+00, %bb59 ], [ %f3.1, %bb64 ]
  %1 = add nuw nsw i64 %0, 1
  %and5 = and i64 %0, 1
  %icmpeq = icmp eq i64 %and5, 0
  %2 = fmul double %f3.04, 2.000000e+00
  %f3.0.pn = select i1 %icmpeq, double %f3.04, double %2
  %f3.1 = fadd double %f3.04, %f3.0.pn
  %exitcond.not = icmp eq i64 %1, 3000000
  br i1 %exitcond.not, label %bb63, label %bb64

bb63:                                           ; preds = %bb64
  ; CHECK:  call void @"_ZN8std$core7printlnEd"(double 0x7FF0000000000000)
  call void @"_ZN8std$core7printlnEd"(double %f3.1)
  ret void
}