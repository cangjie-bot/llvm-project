; RUN: opt < %s -sroa --cangjie-pipeline -S | FileCheck %s

%T = type {i8 addrspace(1)*, i64}
%S = type { i8 addrspace(1)*, i64, i64 }
%Array.intArray = type {[0 x i64]}

; CHECK: %6 = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %3, i8 addrspace(1)* addrspace(1)* %5), !tbaa !0
; CHECK: %.sroa.2.8.copyload = load i64, i64 addrspace(1)* %.sroa.2.8..sroa_cast, align 8, !tbaa !6
; CHECK: %.sroa.4.8.copyload = load i64, i64 addrspace(1)* %.sroa.4.8..sroa_cast, align 8, !tbaa !7
define i64 @foo(i8 addrspace(1)* %.0) {
  %1 = alloca %S
  %2 = bitcast i8 addrspace(1)* %.0 to %T addrspace(1)*
  %3 = getelementptr inbounds %T, %T addrspace(1)* %2, i32 0, i32 0
  %4 = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %.0, i8 addrspace(1)* addrspace(1)* %3)
  %5 = getelementptr inbounds i8, i8 addrspace(1)* %4, i64 0
  %6 = bitcast i8 addrspace(1)* %5 to i8 addrspace(1)* addrspace(1)*
  %7 = call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %4, i8 addrspace(1)* addrspace(1)* %6), !tbaa !6
  %8 = getelementptr inbounds %S, %S* %1, i32 0, i32 0
  store i8 addrspace(1)* %7, i8 addrspace(1)** %8
  %9 = getelementptr inbounds %S, %S* %1, i32 0, i32 1
  %10 = bitcast i64* %9 to i8*
  %11 = getelementptr inbounds i8, i8 addrspace(1)* %4, i64 8
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %10, i8 addrspace(1)* noundef align 8 dereferenceable(16) %11, i64 16, i1 false)
  br label %12

12:
  %13 = getelementptr inbounds %S, %S* %1, i32 0, i32 0
  %14 = load i8 addrspace(1)*, i8 addrspace(1)** %13
  %15 = bitcast i8 addrspace(1)* %14 to %Array.intArray addrspace(1)*
  %16 = getelementptr inbounds %S, %S* %1, i32 0, i32 1
  %17 = load i64, i64* %16
  %18 = getelementptr inbounds %S, %S* %1, i32 0, i32 2
  %19 = load i64, i64* %18
  %20 = add nuw nsw i64 %17, %19
  %21 = getelementptr inbounds %Array.intArray, %Array.intArray addrspace(1)* %15, i32 0, i32 0, i64 %20
  %22 = load i64, i64 addrspace(1)* %21
  ret i64 %22
}

declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly %0, i8 addrspace(1)* noalias nocapture readonly %1, i64 %2, i1 immarg %3) #0
declare i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* nocapture %0, i8 addrspace(1)* addrspace(1)* nocapture %1) #1

attributes #0 = { argmemonly nocallback nofree nounwind willreturn }
attributes #1 = { argmemonly nofree nounwind readonly }

; CHECK: !0 = !{!1, !2, i64 0}
; CHECK-NEXT: !1 = !{!"S", !2, i64 0, !5, i64 8, !5, i64 16}
; CHECK-NEXT: !2 = !{!"pointer", !3}
; CHECK-NEXT: !3 = !{!"omnipotent char", !4}
; CHECK-NEXT: !4 = !{!"Simple Cangjie TBAA"}
; CHECK-NEXT: !5 = !{!"i64", !3}
; CHECK-NEXT: !6 = !{!1, !5, i64 8}
; CHECK-NEXT: !7 = !{!1, !5, i64 16}

!0 = !{!"pointer", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple Cangjie TBAA"}
!3 = !{!"i64", !1}
!4 = !{!"S", !0, i64 0, !3, i64 8, !3, i64 16}
!5 = !{!"T", !4, i64 0, !3, i64 24}
!6 = !{!4, !0, i64 0}