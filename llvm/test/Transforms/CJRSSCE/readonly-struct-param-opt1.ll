; RUN: opt -passes=cj-rssce -S < %s | FileCheck %s

%record.test1 = type {i8 addrspace(1)*, i64, i64}
%record.test2 = type {i64, %record.test1, i64}

declare void @func1(%record.test1*) #0
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)
declare void @init_record2(%record.test2* %ptr)

; CHECK: %8 = bitcast i8* %7 to %record.test1*
; CHECK-NEXT call void @func1(%record.test1* %8)
define void @only_memcpy_func(i8 addrspace(1)* %ptr) {
entry:
  %0 = alloca %record.test1, align 8
  %1 = alloca %record.test2, align 8
  %2 = bitcast %record.test1* %0 to i8*
  %3 = addrspacecast  %record.test2* %1 to %record.test2 addrspace(1)*
  %4 = getelementptr inbounds %record.test2, %record.test2 addrspace(1)* %3, i64 0, i32 1
  %5 = bitcast %record.test1 addrspace(1)* %4 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 8 %2, i8 addrspace(1)* align 8 %5, i64 24, i1 false)
  call void @func1(%record.test1* %0)
  ret void
}

; CHECK: call void @func1(%record.test1* %0)
define void @only_memcpy_func2(i8 addrspace(1)* %ptr) {
entry:
  %0 = alloca %record.test1, align 8
  %1 = alloca %record.test2, align 8
  %2 = alloca %record.test2, align 8
  call void @init_record2(%record.test2* %2)
  %3 = bitcast %record.test2* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %3)
  %4 = bitcast %record.test2* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %3, i8* %4, i64 40, i1 false)
  %5 = bitcast %record.test1* %0 to i8*
  %6 = addrspacecast  %record.test2* %1 to %record.test2 addrspace(1)*
  %7 = getelementptr inbounds %record.test2, %record.test2 addrspace(1)* %6, i64 0, i32 1
  %8 = bitcast %record.test1 addrspace(1)* %7 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 8 %5, i8 addrspace(1)* align 8 %8, i64 24, i1 false)
  %9 = bitcast %record.test2* %1 to i8*
  call void @llvm.lifetime.end.p0i8(i64 40, i8* %9)
  call void @func1(%record.test1* %0)
  ret void
}

attributes #0 = { readonly }
