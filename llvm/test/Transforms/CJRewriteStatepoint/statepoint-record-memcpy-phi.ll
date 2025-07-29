; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record = type { i8 addrspace(1)*, i64 }
%record1 = type { i8 addrspace(1)*, i64, i64 }
%record2 = type { i64, i64 }


define void @foo() #0 gc "cangjie" {
entry:
  %atom.0 = alloca %record
  %atom.1 = alloca %record
  %atom.2 = alloca %record
  %0 = bitcast %record* %atom.0 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %0, i8 0, i64 16, i1 false)
  %1 = bitcast %record* %atom.1 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %2 = bitcast %record* %atom.2 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %2, i8 0, i64 16, i1 false)
  br label %body1

; CHECK: body1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record addrspace(1)*)* @tmp_use, i32 2, i32 0, i8 addrspace(1)* null, %record addrspace(1)* %3) [ "struct-live"(%record* %atom.2, %record* %atom.1) ]
;
body1:                                       ; preds = %entry
  %3 = addrspacecast %record* %atom.1 to %record addrspace(1)*
  call void @tmp_use(i8 addrspace(1)* null, %record addrspace(1)* %3)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %0, i8* align 8 %1, i64 8, i1 false)
  %4 = getelementptr inbounds %record, %record* %atom.0, i64 0, i32 1
  %ret = load i64, i64* %4, align 8
  %icmpeq.i = icmp eq i64 %ret, 0
  br i1 %icmpeq.i, label %tmp1, label %tmp2

; CHECK: tmp1:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record addrspace(1)*)* @foo_test, i32 2, i32 0, i8 addrspace(1)* null, %record addrspace(1)* %5) [ "struct-live"(%record* %atom.0, %record* %atom.2) ]
;
tmp1:                                       ; preds = %body1
  %5 = addrspacecast %record* %atom.0 to %record addrspace(1)*
  call void @foo_test(i8 addrspace(1)* null, %record addrspace(1)* %5)
  br label %tmpend

; CHECK: tmp2
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record addrspace(1)*)* @foo_test, i32 2, i32 0, i8 addrspace(1)* null, %record addrspace(1)* %6) [ "struct-live"(%record* %atom.0, %record* %atom.2, %record* %atom.1) ]
;
tmp2:                                       ; preds = %body1
  %6 = addrspacecast %record* %atom.1 to %record addrspace(1)*
  call void @foo_test(i8 addrspace(1)* null, %record addrspace(1)* %6)
  br label %tmpend

; CHECK: tmpend
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record addrspace(1)*)* @tmp_use, i32 2, i32 0, i8 addrspace(1)* null, %record addrspace(1)* %7) [ "struct-live"(%record* %atom.2, %record* %atom.0) ]
;
tmpend:                                    ; preds = %tmp2, %tmp1
  %in = phi %record* [ %atom.0, %tmp1 ], [ %atom.2, %tmp2 ]
  %7 = addrspacecast %record* %in to %record addrspace(1)*
  call void @tmp_use(i8 addrspace(1)* null, %record addrspace(1)* %7)
  ret void
}


declare void @foo_test(i8 addrspace(1)* %arg0, %record addrspace(1)* %arg1) #0 gc "cangjie"
declare void @tmp_use(i8 addrspace(1)* %arg0, %record addrspace(1)* %arg1) #0 gc "cangjie"

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

attributes #0 = { "hasRcdParam" }
