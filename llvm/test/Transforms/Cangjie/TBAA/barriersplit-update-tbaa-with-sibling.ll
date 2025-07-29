; RUN: opt < %s -cj-barrier-split --cangjie-pipeline  -S | FileCheck %s

%T = type {%S, i64}
%S = type { i8 addrspace(1)*, i64, i64 }

; CHECK: 9:
; CHECK-NEXT: %10 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 0
; CHECK-NEXT: %11 = bitcast %S* %1 to i8*
; CHECK-NEXT: %12 = bitcast i8 addrspace(1)* %10 to i8 addrspace(1)* addrspace(1)*
; CHECK-NEXT: %13 = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %3, i8 addrspace(1)* addrspace(1)* %12), !tbaa !7
; CHECK-NEXT: %14 = bitcast i8* %11 to i8 addrspace(1)**
; CHECK-NEXT: store i8 addrspace(1)* %13, i8 addrspace(1)** %14, align 8, !tbaa !8
; CHECK-NEXT: %15 = getelementptr inbounds i8, i8* %11, i32 8
; CHECK-NEXT: %16 = getelementptr inbounds i8, i8 addrspace(1)* %10, i32 8
; CHECK-NEXT: call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 8 %15, i8 addrspace(1)* align 8 %16, i64 16, i1 false), !tbaa.struct !9
; CHECK-NEXT: ret void
define void @foo(i8 addrspace(1)* %.0) gc "cangjie" {
  %1 = alloca %S
  %2 = bitcast i8 addrspace(1)* %.0 to i8 addrspace(1)* addrspace(1)*
  ; %.0: %T addrspace(1)**
  %3 = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %.0, i8 addrspace(1)* addrspace(1)* %2)
  %4 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 24
  %5 = bitcast i8 addrspace(1)* %4 to i64 addrspace(1)*
  %6 = load i64, i64 addrspace(1)* %5, !tbaa !6
  %7 = icmp slt i64 %6, 1
  br i1 %7, label %8, label %9

8:
  unreachable

9:
  %10 = getelementptr inbounds i8, i8 addrspace(1)* %3, i64 0
  %11 = bitcast %S* %1 to i8*
  call void @llvm.cj.gcread.struct(i8* nonnull %11, i8 addrspace(1)* %3, i8 addrspace(1)* %10, i64 24)
  ret void
}

declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly %0, i8 addrspace(1)* noalias nocapture readonly %1, i64 %2, i1 immarg %3) #0
declare i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* nocapture %0, i8 addrspace(1)* addrspace(1)* nocapture %1) #1
declare void @llvm.cj.gcread.struct(i8* writeonly %0, i8 addrspace(1)* noalias nocapture %1, i8 addrspace(1)* noalias nocapture readonly %2, i64 %3) #2

attributes #0 = { argmemonly nocallback nofree nounwind willreturn }
attributes #1 = { argmemonly nofree nounwind readonly }
attributes #2 = { argmemonly nounwind }

; CHECK: !0 = !{!1, !6, i64 24}
; CHECK-NEXT: !1 = !{!"T", !2, i64 0, !6, i64 24}
; CHECK-NEXT: !2 = !{!"S", !3, i64 0, !6, i64 8, !6, i64 16}
; CHECK-NEXT: !3 = !{!"pointer", !4}
; CHECK-NEXT: !4 = !{!"omnipotent char", !5}
; CHECK-NEXT: !5 = !{!"Simple Cangjie TBAA"}
; CHECK-NEXT: !6 = !{!"i64", !4}
; CHECK-NEXT: !7 = !{!1, !3, i64 0}
; CHECK-NEXT: !8 = !{!2, !3, i64 0}
; CHECK-NEXT: !9 = !{i64 0, i64 8, !10, i64 8, i64 8, !11, i64 16, i64 8, !11}
; CHECK-NEXT: !10 = !{!3, !3, i64 0}
; CHECK-NEXT: !11 = !{!6, !6, i64 0}
!0 = !{!"pointer", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple Cangjie TBAA"}
!3 = !{!"i64", !1}
!4 = !{!"S", !0, i64 0, !3, i64 8, !3, i64 16}
!5 = !{!"T", !4, i64 0, !3, i64 24}
!6 = !{!5, !3, i64 24}