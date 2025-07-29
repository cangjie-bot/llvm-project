; RUN: opt -passes=cj-rssce -S < %s | FileCheck %s

%record.test1 = type {i8 addrspace(1)*, i64, i64}
%ArrayLayout = type {i8 addrspace(1)*, [0 x %record.test1]}

declare void @func1(%record.test1*) #0
declare void @llvm.memcpy.p0i8.p108.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare void @init_array(%ArrayLayout* %ptr)

; CHECK: %9 = bitcast i8 addrspace(1)** %2 to %record.test1*
; CHECK-NEXT call void func1(%record.test1* %9)
define void @array_func() {
entry:
  %0 = alloca %ArrayLayout, align 8
  %1 = alloca %record.test1, align 8
  call void @init_array(%ArrayLayout* %0)
  br label %loop.header

loop.header:
  %i = phi i64 [0, %entry], [%i.1, %loop.header]
  %i.1 = add i64 %i, 1
  %2 = getelementptr inbounds %ArrayLayout, %ArrayLayout* %0, i32 0, i32 1, i64 %i, i32 0
  %3 = getelementptr inbounds %record.test1, %record.test1* %1, i32 0, i32 0
  %4 = load i8 addrspace(1)*, i8 addrspace(1)** %2, align 8
  store i8 addrspace(1)* %4, i8 addrspace(1)** %3, align 8
  %5 = getelementptr inbounds %ArrayLayout, %ArrayLayout* %0, i32 0, i32 1, i64 %i, i32 1
  %6 = getelementptr inbounds %record.test1, %record.test1* %1, i32 0, i32 1
  %7 = bitcast i64* %5 to i8*
  %8 = bitcast i64* %6 to i8*
  call void @llvm.memcpy.p0i8.p108.i64(i8* %8, i8* %7, i64 16, i1 false)
  call void @func1(%record.test1* %1)
  %icmp = icmp eq i64 %i.1, 100
  br i1 %icmp, label %exit, label %loop.header

exit:
  ret void
}

attributes #0 = { readonly }