; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s


%record = type { %record1, %record2, i8 addrspace(1)* }
%record1 = type { i8* }
%record2 = type { i1, i64 }

declare void @test_func()
declare void @default(i8 addrspace(1)*)
declare void @llvm.memset.p0i8.i64(i8* writeonly, i8, i64, i1 immarg)

; CHECK: entry:
; CHECK:    [[TMP0:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @test_func, i32 0, i32 0)
; CHECK: bb1:
; CHECK:    [[TMP1:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*)* @default, i32 1, i32 0, i8 addrspace(1)* %2) [ "struct-live"(%record* %0) ]

define void @foo(i8* %arg1, i8* %arg2) #0 gc "cangjie" {
entry:
  %0 = alloca %record, align 8
  call void @test_func()
  %1 = bitcast %record* %0 to i8*
  %2 = addrspacecast i8* %1 to i8 addrspace(1)*
  %3 = getelementptr inbounds %record, %record* %0, i64 0, i32 1
  %4 = bitcast %record2* %3 to i8*
  %5 = bitcast %record* %0 to i8**
  br label %bb1

bb1:                                    ; preds = %entry
  store i8* %arg1, i8** %5, align 8
  call void @llvm.memset.p0i8.i64(i8* %4, i8 0, i64 24, i1 false)
  call void @default(i8 addrspace(1)* %2)
  ret void
}
