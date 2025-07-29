; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%ArrayBase = type { i8*, i64 }

declare i8 addrspace(1)* @CJ_MCC_GetObjClass(i8 addrspace(1)*)
declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)
declare void @test_func()
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

; CHECK: entry:
; CHECK:   [[TMP0:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @test_func, i32 0, i32 0) [ "struct-live"({ %ArrayBase, [16 x i8 addrspace(1)*] }* %0) ]
; CHECK: bb5:
; CHECK:   [[TMP1:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i8 addrspace(1)* (i8*, i32)* @CJ_MCC_NewObjectStub, i32 2, i32 0, i8* %ArrayKlass, i32 24) [ "struct-live"({ %ArrayBase, [16 x i8 addrspace(1)*] }* %0) ]

define i8 addrspace(1)* @foo(i64 %w, i8* %ArrayKlass) #0 gc "cangjie" {
entry:
  %0 = alloca { %ArrayBase, [16 x i8 addrspace(1)*] }, align 8, !ea_val !0
  %1 = bitcast { %ArrayBase, [16 x i8 addrspace(1)*] }* %0 to i8**
  store i8* %ArrayKlass, i8** %1, align 8
  %2 = getelementptr inbounds { %ArrayBase, [16 x i8 addrspace(1)*] }, { %ArrayBase, [16 x i8 addrspace(1)*] }* %0, i64 0, i32 1
  %3 = bitcast [16 x i8 addrspace(1)*]* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %3, i8 0, i64 128, i1 false)
  call void @test_func()
  %4 = bitcast { %ArrayBase, [16 x i8 addrspace(1)*] }* %0 to i8*
  %5 = addrspacecast i8* %4 to i8 addrspace(1)*

  %icmp1 = icmp sgt i64 %w, 0
  br i1 %icmp1, label %bb5, label %bb6

bb5:                                  ; preds = %entry
  %6 = call i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8 *%ArrayKlass, i32 24)
  br label %bb6

bb6:                                   ; preds = %entry, %bb5
  %phi.val = phi i8 addrspace(1)* [ %5, %entry ], [ %6, %bb5 ]
  %result = call i8 addrspace(1)* @CJ_MCC_GetObjClass(i8 addrspace(1)* %phi.val)
  ret i8 addrspace(1)* %result
}

!0 = !{}
