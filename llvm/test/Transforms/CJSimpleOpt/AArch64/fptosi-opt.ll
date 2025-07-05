; RUN: opt -passes=cj-simple-opt -S < %s | FileCheck %s
target triple = "aarch64--linux-gnu"

define void @"foo"(double* %X) gc "cangjie" {
bb1:
  ; CHECK:        %1 = fptosi double %0 to i64
  ; CHECK-NEXT:   %2 = call i64 @llvm.cj.get.fp.state.i64(i64 %1)
  ; CHECK-NEXT:   %3 = and i64 %2, 1
  ; CHECK-NEXT:   %4 = icmp eq i64 %3, 0
  ; CHECK-NEXT:   br i1 %4, label %upper.bound.ok, label %fp.convert.exception

  %0 = load double, double* %X, align 8
  %1 = bitcast double %0 to i64
  %2 = and i64 %1, 9218868437227405312
  %notInfOrNan = icmp ne i64 %2, 9218868437227405312
  br i1 %notInfOrNan, label %not.inf.nan, label %inf.or.nan

not.inf.nan:
  %f2i.lt.min = fcmp olt double 0xC3E0000000000001, %0
  br i1 %f2i.lt.min, label %lower.bound.ok, label %lower.bound.overflow

lower.bound.ok:
  %f2i.gt.max = fcmp olt double %0, 0x43E0000000000000
  br i1 %f2i.gt.max, label %upper.bound.ok, label %upper.bound.overflow

upper.bound.ok:
  %3 = fptosi double %0 to i64
  br label %bb2

inf.or.nan:
  unreachable

lower.bound.overflow:
  unreachable

upper.bound.overflow:
  unreachable

bb2:
  ret void
}
