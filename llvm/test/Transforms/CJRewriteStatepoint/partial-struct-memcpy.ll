; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record = type { i32, i8 addrspace(1)* }

%record1 = type { i16, i16, i64, i1, i1, i1 }
%record2 = type { i32, i32, i64, i1, i1, i1 }
%record3 = type { %"record4", i64 }
%record4 = type { i8 addrspace(1)*, i64, i64 }

declare void @test_func()
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1 immarg)

; CHECK: entry:
; CHECK:    [[TMP0:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @test_func, i32 0, i32 0)
; CHECK: bb1:
; CHECK:    [[TMP1:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @test_func, i32 0, i32 0) [ "struct-live"(<{ %record1, %record2, %record3, %record4 }>* %r) ]

define void @foo(i8* %arg1, i8* %arg2) #0 gc "cangjie" {
entry:
  %r = alloca <{ %record1, %record2, %record3, %record4 }>, align 8
  call void @test_func()
  %0 = bitcast <{ %record1, %record2, %record3, %record4 }>* %r to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %0, i8* align 8 %arg1, i64 24, i1 false)
  br label %bb1

bb1:                                    ; preds = %entry
  %1 = getelementptr inbounds <{ %record1, %record2, %record3, %record4 }>, <{ %record1, %record2, %record3, %record4 }>* %r, i64 0, i32 1
  %2 = bitcast %record2* %1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %2, i8* align 8 %arg1, i64 80, i1 false)
  call void @test_func()
  br label %bb2

bb2:                                    ; preds = %bb1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %arg2, i8* align 8 %2, i64 102, i1 false)
  ret void
}
