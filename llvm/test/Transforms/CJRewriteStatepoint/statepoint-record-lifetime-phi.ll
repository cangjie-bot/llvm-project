; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s


%struct = type { i8 addrspace(1)* }

define void @booo() gc "cangjie" {
entry:
  %r1 = alloca %struct
  %r2 = alloca %struct
  %0 = bitcast %struct* %r1 to i8*
  call void @llvm.memset.p0i8.i64(i8* %0, i8 0, i64 8, i1 false)
  br label %bb0

; CHECK:  bb0:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i64 ()* @tmp_use, i32 0, i32 0) [ "struct-live"(%struct* %r1, %struct* %r2) ]
;
bb0:
  %1 = bitcast %struct* %r2 to i8*
  %2 = call i64 @tmp_use()
  %icmpeq.i = icmp eq i64 %2, 0
  br i1 %icmpeq.i, label %bb1, label %bb2

; CHECK:  bb1:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @testcase1, i32 0, i32 0) [ "struct-live"(%struct* %r2, %struct* %r1) ]
;
bb1:
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %1)
  call void @llvm.memset.p0i8.i64(i8* %1, i8 0, i64 8, i1 false)
  call void @testcase1()
  br label %bbend

; CHECK:  bb2:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @testcase2, i32 0, i32 0) [ "struct-live"(%struct* %r2, %struct* %r1) ]
;
bb2:
  call void @testcase2()
  br label %bbend

; CHECK:  bbend:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (%struct addrspace(1)*)* @test, i32 1, i32 0, %struct addrspace(1)* %4) [ "struct-live"(%struct* %r1, %struct* %r2) ]
;
bbend:
  %sink = phi %struct* [%r2, %bb1], [%r1, %bb2]
  %3 = addrspacecast %struct* %sink to %struct addrspace(1)*
  call void @test(%struct addrspace(1)* %3)
  ret void
}


declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)

declare i64 @tmp_use() gc "cangjie"
declare void @testcase1() gc "cangjie"
declare void @testcase2() gc "cangjie"
declare void @test(%struct addrspace(1)* %arg0) gc "cangjie"
