; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record0 = type { i8 addrspace(1)* }
%record1 = type { i8 addrspace(1)*, i64, i64 }
%record2 = type { i64, i64 }


define void @foo() #0 gc "cangjie" {
entry:
  %atom.0 = alloca %record0
  %atom.1 = alloca %record1
  %atom.2 = alloca %record2
  %atom.3 = alloca %record2
  %atom.4 = alloca %record2
  %0 = bitcast %record0* %atom.0 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %0, i8 0, i64 8, i1 false)
  %1 = bitcast %record1* %atom.1 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %2 = bitcast %record2* %atom.2 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %2, i8 0, i64 16, i1 false)
  %3 = bitcast %record2* %atom.3 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %3, i8 0, i64 16, i1 false)
  %4 = bitcast %record2* %atom.4 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %4, i8 0, i64 16, i1 false)
  br label %body1

; CHECK: body1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*)* @tmp_use, i32 2, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %5) [ "struct-live"(%record1* %atom.1) ]
;
body1:                                       ; preds = %entry
  %5 = addrspacecast %record1* %atom.1 to %record1 addrspace(1)*
  %atom.1.cast = bitcast %record1 addrspace(1)* %5 to i8 addrspace(1)*
  call void @tmp_use(i8 addrspace(1)* null, %record1 addrspace(1)* %5)
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 8 %0, i8 addrspace(1)* align 8 %atom.1.cast, i64 8, i1 false)
  %6 = getelementptr inbounds %record2, %record2* %atom.3, i64 0, i32 0
  %count = load i64, i64* %6, align 8
  %7 = and i64 %count, 1
  %icmpeq.i = icmp eq i64 %7, 0
  br i1 %icmpeq.i, label %tmp1, label %tmp2

; CHECK: tmp1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @default_foo_test, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %5, i8 addrspace(1)* null, %record1 addrspace(1)* %9) [ "struct-live"(%record0* %atom.0, %record1* %atom.1) ]
;
tmp1:                                       ; preds = %body1
  %8 = bitcast %record2* %atom.4 to i8*
  %9 = addrspacecast %record2* %atom.4 to %record1 addrspace(1)*
  call void @default_foo_test(i8 addrspace(1)* null, %record1 addrspace(1)* %5, i8 addrspace(1)* null, %record1 addrspace(1)* %9)
  br label %tmpend1

; CHECK: tmp2
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @default_foo_test, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %5, i8 addrspace(1)* null, %record1 addrspace(1)* %11) [ "struct-live"(%record0* %atom.0, %record1* %atom.1) ]
;
tmp2:                                       ; preds = %body1
  %10 = bitcast %record2* %atom.3 to i8*
  %11 = addrspacecast %record2* %atom.3 to %record1 addrspace(1)*
  call void @default_foo_test(i8 addrspace(1)* null, %record1 addrspace(1)* %5, i8 addrspace(1)* null, %record1 addrspace(1)* %11)
  br label %tmpend1

; CHECK: tmpend1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*)* @tmp_use, i32 2, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %5) [ "struct-live"(%record0* %atom.0, %record1* %atom.1) ]
; CHECK:  [[TOKEN:%.*]] = tail call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i8 addrspace(1)* (i8*, i32)* @CJ_MCC_NewObjectStub, i32 2, i32 0, i8* %.sink, i32 40) [ "struct-live"(%record0* %atom.0, %record1* %atom.1) ]
;
tmpend1:                                    ; preds = %tmp2, %tmp1
  %.sink = phi i8* [ %10, %tmp2 ], [ %8, %tmp1 ]
  call void @tmp_use(i8 addrspace(1)* null, %record1 addrspace(1)* %5)
  %12 = tail call i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* %.sink, i32 40)
  %13 = getelementptr inbounds i8, i8 addrspace(1)* %12, i64 8
  %14 = addrspacecast i8* %.sink to i8 addrspace(1)*
  %15 = call cangjiegccc i32 @GetGCPhase()
  %16 = icmp sle i32 %15, 8
  br i1 %16, label %gcNoRunning2, label %gcRunning0

gcRunning0:                                      ; preds = %tmpend1
  call void @llvm.cj.gcwrite.struct.p1i8(i8 addrspace(1)* %12, i8 addrspace(1)* %13, i8 addrspace(1)* %14, i64 16)
  br label %storeFinish1

gcNoRunning2:                                    ; preds = %tmpend1
  call void @llvm.memcpy.p1i8.p0i8.i64(i8 addrspace(1)* align 8 %13, i8* align 8 %.sink, i64 16, i1 false)
  br label %storeFinish1

; CHECK: storeFinish1
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*)* @tmp_use, i32 2, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %5) [ "struct-live"(%record0* %atom.0, %record1* %atom.1) ]
;
storeFinish1:                                    ; preds = %gcNoRunning2, %gcRunning0
  call void @tmp_use(i8 addrspace(1)* null, %record1 addrspace(1)* %5)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %1, i8* nonnull align 8 %0, i64 8, i1 false)
  ret void
}


declare void @default_foo_test(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1, i8 addrspace(1)* %arg2, %record1 addrspace(1)* %arg3) #0 gc "cangjie"
declare void @tmp_use(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1) #0 gc "cangjie"

declare cangjiegccc i32 @GetGCPhase() #1
declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)
declare void @llvm.cj.gcwrite.struct.p1i8(i8 addrspace(1)*, i8 addrspace(1)* nocapture writeonly, i8 addrspace(1)* nocapture readonly, i64)

declare void @llvm.memcpy.p1i8.p0i8.i64(i8 addrspace(1)* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

attributes #0 = { "hasRcdParam" }
attributes #1 = { "cj-runtime" "gc-leaf-function" }
