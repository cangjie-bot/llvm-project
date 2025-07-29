; RUN: opt < %s -insert-cj-tbaa  -S | FileCheck %s

; CHECK: %3 = load i8, i8* %2, align 1
; CHECK: %4 = load i8, i8* %1, align 1, !tbaa !0
define void @foo() {
bb0:
  %0 = alloca [1 x i1], align 1
  %1 = alloca i8, align 1
  %2 = bitcast [1 x i1]* %0 to i8*
  %3 = load i8, i8* %2, align 1
  %4 = load i8, i8* %1, align 1
  ret void
}

; CHECK: !0 = !{!1, !1, i64 0}
; CHECK-NEXT: !1 = !{!"i8", !2}
; CHECK-NEXT: !2 = !{!"omnipotent char", !3}
; CHECK-NEXT: !3 = !{!"Simple Cangjie TBAA"}