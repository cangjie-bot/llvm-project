; RUN: opt < %s -insert-cj-tbaa  -S | FileCheck %s

%type = type {i8 addrspace(1)*, i64, i64}

; CHECK: store i64 1, i64* %3, align 8, !tbaa !0
define void @foo() {
bb0:
  %0 = alloca %type, align 8
  %1 = bitcast %type* %0 to i8*
  %2 = getelementptr inbounds i8, i8* %1, i32 16
  %3 = bitcast i8* %2 to i64*
  store i64 1, i64* %3, align 8
  ret void
}

; CHECK: !0 = !{!1, !5, i64 16}
; CHECK-NEXT: !1 = !{!"type", !2, i64 0, !5, i64 8, !5, i64 16}
; CHECK-NEXT: !2 = !{!"pointer", !3}
; CHECK-NEXT: !3 = !{!"omnipotent char", !4}
; CHECK-NEXT: !4 = !{!"Simple Cangjie TBAA"}
; CHECK-NEXT: !5 = !{!"i64", !3}