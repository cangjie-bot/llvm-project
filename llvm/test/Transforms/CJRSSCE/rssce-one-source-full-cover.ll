; RUN: opt -passes=cj-rssce -S < %s | FileCheck %s

%record.T = type { %record.S, i64 }
%record.S = type { i8 addrspace(1)*, i64, i64 }

%ObjLayout.0 = type { i8* }
%ObjLayout.T = type { %ObjLayout.0, %record.T }

; CHECK: bb5:
; CHECK: %30 = call i64 @f1(i8* null, %record.T* nonnull %3, %record.T* nonnull %2)
define i64 @foo(i8 addrspace(1)* nocapture readonly %this, i8 addrspace(1)* nocapture readonly %other) {
bb0:
  %0 = alloca %record.T, align 8
  %1 = alloca %record.T, align 8
  %2 = alloca %record.T, align 8
  %3 = alloca %record.T, align 8
  %4 = bitcast i8 addrspace(1)* %this to %ObjLayout.T addrspace(1)*
  %5 = getelementptr inbounds %ObjLayout.T, %ObjLayout.T addrspace(1)* %4, i64 0, i32 1, i32 0, i32 0
  %6 = tail call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %this, i8 addrspace(1)* addrspace(1)* %5)
  %7 = getelementptr inbounds %record.T, %record.T* %3, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %6, i8 addrspace(1)** %7, align 8
  %8 = getelementptr inbounds %record.T, %record.T* %3, i64 0, i32 0, i32 1
  %9 = bitcast i64* %8 to i8*
  %10 = getelementptr inbounds %ObjLayout.T, %ObjLayout.T addrspace(1)* %4, i64 0, i32 1, i32 0, i32 1
  %11 = bitcast i64 addrspace(1)* %10 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %9, i8 addrspace(1)* noundef align 8 dereferenceable(24) %11, i64 24, i1 false)
  %12 = bitcast i8 addrspace(1)* %other to %ObjLayout.T addrspace(1)*
  %13 = getelementptr inbounds %ObjLayout.T, %ObjLayout.T addrspace(1)* %12, i64 0, i32 1, i32 0, i32 0
  %14 = tail call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %other, i8 addrspace(1)* addrspace(1)* %13)
  %15 = getelementptr inbounds %record.T, %record.T* %2, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %14, i8 addrspace(1)** %15, align 8
  %16 = getelementptr inbounds %record.T, %record.T* %2, i64 0, i32 0, i32 1
  %17 = bitcast i64* %16 to i8*
  %18 = getelementptr inbounds %ObjLayout.T, %ObjLayout.T addrspace(1)* %12, i64 0, i32 1, i32 0, i32 1
  %19 = bitcast i64 addrspace(1)* %18 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %17, i8 addrspace(1)* noundef align 8 dereferenceable(24) %19, i64 24, i1 false)
  %20 = call i64 @f1(i8* null, %record.T* nonnull %3, %record.T* nonnull %2)
  %21 = tail call i64 @f2(i64 %20, i64 2)
  %cond = icmp eq i64 %21, 2
  br i1 %cond, label %common.ret, label %bb5

common.ret:                                       ; preds = %bb5, %bb0
  %common.ret.op = phi i64 [ 0, %bb0 ], [ %spec.select, %bb5 ]
  ret i64 %common.ret.op

bb5:                                              ; preds = %bb0
  %22 = tail call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %this, i8 addrspace(1)* addrspace(1)* %5)
  %23 = getelementptr inbounds %record.T, %record.T* %1, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %22, i8 addrspace(1)** %23, align 8
  %24 = getelementptr inbounds %record.T, %record.T* %1, i64 0, i32 0, i32 1
  %25 = bitcast i64* %24 to i8*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %25, i8 addrspace(1)* noundef align 8 dereferenceable(24) %11, i64 24, i1 false)
  %26 = tail call i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* %other, i8 addrspace(1)* addrspace(1)* %13)
  %27 = getelementptr inbounds %record.T, %record.T* %0, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %26, i8 addrspace(1)** %27, align 8
  %28 = getelementptr inbounds %record.T, %record.T* %0, i64 0, i32 0, i32 1
  %29 = bitcast i64* %28 to i8*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %29, i8 addrspace(1)* noundef align 8 dereferenceable(24) %19, i64 24, i1 false)
  %30 = call i64 @f1(i8* null, %record.T* nonnull %1, %record.T* nonnull %0)
  %31 = tail call i64 @f2(i64 %30, i64 1)
  %cond1 = icmp eq i64 %31, 2
  %spec.select = select i1 %cond1, i64 1, i64 -1
  br label %common.ret
}

declare i64 @f1(i8*, %record.T* nocapture readonly, %record.T* nocapture readonly) #3
declare i64 @f2(i64, i64) #0

declare i8 addrspace(1)* @llvm.cj.gcread.ref(i8 addrspace(1)* nocapture, i8 addrspace(1)* addrspace(1)* nocapture) #1
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg) #2

attributes #0 = { readnone }
attributes #1 = { argmemonly nounwind readonly }
attributes #2 = { argmemonly nocallback nofree nounwind willreturn }
attributes #3 = { argmemonly }
