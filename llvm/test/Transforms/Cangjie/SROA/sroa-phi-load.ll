; RUN: opt < %s -cangjie-pipeline -sroa -S | FileCheck %s
; RUN: opt < %s -cangjie-pipeline -passes=sroa -S | FileCheck %s

%record = type { i8 addrspace(1)*, i64, i64 }

declare void @llvm.cj.memset.p0i8(i8*, i8, i64, i1)
declare void @getObjClass(i8 addrspace(1)*)

; CHECK: bb0
; CHECK-NOT: store
; CHECK-NOT: load
; CHECK: bb1
; CHECK-NOT: store
; CHECK-NOT: load
; CHECK: bb2
; CHECK-NOT: store
; CHECK-NOT: load
; CHECK: bbend
; CHECK: %phi.r.sroa.phi.sroa.speculated = phi i8 addrspace(1)* [ %obj1, %bb0 ], [ %obj2, %bb1 ], [ %obj3, %bb2 ]
; CHECK-NOT: load


define void @foo(i64 %c, i8 addrspace(1)* %obj1, i8 addrspace(1)* %obj2, i8 addrspace(1)* %obj3, i32 %0) gc "cangjie" {
bb0:
  %r1 = alloca %record, align 8
  %r2 = alloca %record, align 8
  %r3 = alloca %record, align 8
  %1 = bitcast %record* %r1 to i8*
  %2 = bitcast %record* %r2 to i8*
  %3 = bitcast %record* %r3 to i8*
  %4 = getelementptr inbounds %record, %record* %r1, i64 0, i32 0
  store i8 addrspace(1)* %obj1, i8 addrspace(1)** %4, align 8
  %5 = getelementptr inbounds %record, %record* %r1, i64 0, i32 1
  %6 = bitcast i64* %5 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %6, i8 0, i64 16, i1 false)
  %icmp1 = icmp ugt i64 %c, 4
  br i1 %icmp1 , label %bbend, label %bb1

bb1:
  %7 = getelementptr inbounds %record, %record* %r2, i64 0, i32 0
  store i8 addrspace(1)* %obj2, i8 addrspace(1)** %7, align 8
  %8 = getelementptr inbounds %record, %record* %r2, i64 0, i32 1
  %9 = bitcast i64* %8 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %9, i8 0, i64 16, i1 false)
  %icmp2 = icmp ugt i64 %c, 2
  br i1 %icmp2 , label %bbend, label %bb2

bb2:
  %10 = getelementptr inbounds %record, %record* %r3, i64 0, i32 0
  store i8 addrspace(1)* %obj3, i8 addrspace(1)** %10, align 8
  %11 = getelementptr inbounds %record, %record* %r3, i64 0, i32 1
  %12 = bitcast i64* %11 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %12, i8 0, i64 16, i1 false)
  br label %bbend

bbend:
  %phi.r = phi %record* [ %r1, %bb0 ], [ %r2, %bb1 ], [ %r3, %bb2 ]
  %13 = getelementptr %record, %record* %phi.r, i64 0, i32 0
  %14 = addrspacecast i8 addrspace(1)** %13 to i8 addrspace(1)* addrspace(1)*
  %15 = addrspacecast i8 addrspace(1)* addrspace(1)* %14 to i8 addrspace(1)**
  %16 = load i8 addrspace(1)*, i8 addrspace(1)** %15, align 8
  call void @getObjClass(i8 addrspace(1)* %16)
  ret void
}