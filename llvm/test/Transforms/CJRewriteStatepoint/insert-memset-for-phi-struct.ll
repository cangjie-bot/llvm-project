; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s


%struct = type { i8 addrspace(1)* }

define void @booo(i64 %0) gc "cangjie" {

; CHECK:  entry:
; CHECK:  call void @llvm.memset.p0i8.i64(i8* align 8 %1, i8 0, i64 8, i1 false)
; CHECK:  call void @llvm.memset.p0i8.i64(i8* align 8 %2, i8 0, i64 8, i1 false)
;
entry:
  %r1 = alloca %struct
  %r2 = alloca %struct
  br label %bb0

bb0:
  %1 = bitcast %struct* %r2 to i8*
  %icmpeq.i = icmp eq i64 %0, 0
  br i1 %icmpeq.i, label %bb1, label %bbend

; CHECK:  bb1:
; CHECK-NEXT:  call void @llvm.lifetime.start.p0i8(i64 8, i8* %3)
; CHECK-NEXT:  call void @llvm.memset.p0i8.i64(i8* align 8 %3, i8 0, i64 8, i1 false)
;
bb1:
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %1)
  call void @testcase1()
  %icmpeq.g = icmp ugt i64 %0, 4
  br i1 %icmpeq.g, label %bb2, label %bbend

; CHECK:  bb2:
; CHECK:  call void @llvm.memset.p0i8.i64(i8* %3, i8 %v3, i64 8, i1 false)
;
bb2:
  %v = call i8 @testcase2()
  call void @llvm.memset.p0i8.i64(i8* %1, i8 %v, i64 8, i1 false)
  br label %bbend

bbend:
  %sink = phi %struct* [%r1, %bb0], [%r1, %bb1], [%r2, %bb2]
  %2 = addrspacecast %struct* %sink to %struct addrspace(1)*
  call void @test(%struct addrspace(1)* %2)
  ret void
}


declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)

declare void @testcase1() gc "cangjie"
declare i8 @testcase2() gc "cangjie"
declare void @test(%struct addrspace(1)* %arg0) gc "cangjie"
