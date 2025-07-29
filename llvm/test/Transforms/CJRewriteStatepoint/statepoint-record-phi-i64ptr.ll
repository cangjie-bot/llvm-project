; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record0 = type { i8 addrspace(1)* }
%record1 = type { i8 addrspace(1)*, i64, i64 }

define void @foo() #0 gc "cangjie" {
entry:
  %atom.0 = alloca %record0
  %atom.1 = alloca %record1
  %atom.2 = alloca %record1
  %0 = bitcast %record0* %atom.0 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %0, i8 0, i64 8, i1 false)
  %1 = bitcast %record1* %atom.1 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %2 = getelementptr inbounds %record1, %record1* %atom.1, i64 0, i32 2
  %count = load i64, i64* %2, align 8
  %icmpeq.i = icmp eq i64 %count, 0
  br i1 %icmpeq.i, label %tmp1, label %tmpend1

; CHECK: tmp1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @foo_test, i32 0, i32 0) [ "struct-live"(%record1* %atom.2, %record0* %atom.0) ]
;
tmp1:                                       ; preds = %entry
  call void @foo_test()
  %3 = bitcast %record0* %atom.0 to i8 addrspace(1)**
  %v = load i8 addrspace(1)*, i8 addrspace(1)** %3, align 8
  %ptr = bitcast %record1* %atom.1 to i8 addrspace(1)**
  store i8 addrspace(1)* %v, i8 addrspace(1)** %ptr
  br label %tmpend1

; CHECK: tmpend1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @tmp_test1, i32 0, i32 0) [ "struct-live"(%record1* %atom.2, %record1* %atom.1) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @tmp_test2, i32 0, i32 0)
;
tmpend1:                                    ; preds = %entry, %tmp1
  %sink = phi %record1* [ %atom.1, %entry ], [ %atom.2, %tmp1 ]
  %sink.ptr = getelementptr inbounds %record1, %record1* %sink, i64 0, i32 0
  call void @tmp_test1()
  %ptr1 = load i8 addrspace(1)*, i8 addrspace(1)** %sink.ptr
  %sink.value = getelementptr inbounds %record1, %record1* %sink, i64 0, i32 2
  call void @tmp_test2()
  %value1 = load i64, i64* %sink.value
  ret void
}


declare void @foo_test() gc "cangjie"
declare void @tmp_test1() gc "cangjie"
declare void @tmp_test2() gc "cangjie"
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)
