; RUN: opt -cj-rewrite-statepoint -S < %s | FileCheck %s
; RUN: opt -passes=cj-rewrite-statepoint -S < %s | FileCheck %s

%record1 = type { i8 addrspace(1)*, i64 }
%record2 = type { i8 addrspace(1)*, i64, i64, i1 }
%struct = type { i1, i32 }

declare void @g0(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1, i8 addrspace(1)* %arg2, %record1 addrspace(1)* %arg3) #0 gc "cangjie"
declare void @g1(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1) #0 gc "cangjie"
declare i8 addrspace(1)* @g2(i8 addrspace(1)* %arg0, %record2 addrspace(1)* %arg1) #0 gc "cangjie"
declare i8* @g3(i8 addrspace(1)* %arg) #0 gc "cangjie"
declare i8* @g4(i64* %arg0, i32 %arg1, i32 %arg2, i64 %arg3, i64 %arg4) #0 gc "cangjie"
declare void @g5(i32 %arg) #0 gc "cangjie"
declare void @g6(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1) #0 gc "cangjie"
declare void @g7(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1, i1 %arg2) #0 gc "cangjie"
declare i1 @g8(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1, i8 addrspace(1)* %arg2, %record1 addrspace(1)* %arg3) #0 gc "cangjie"
declare i1 @g9(i8 addrspace(1)* %arg0, %record1 addrspace(1)* %arg1) #0 gc "cangjie"
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i64 @foo() #0 gc "cangjie" {
entry:
  %0 = alloca %record1
  %1 = alloca %record1
  %2 = alloca %record1
  %3 = alloca %record1
  %4 = alloca %record1
  %5 = alloca %record1
  %6 = alloca %record1
  %7 = alloca %record1
  %8 = alloca %record1
  %9 = alloca %struct
  %10 = alloca %record2
  %11 = alloca %record2
  %12 = alloca %record1
  %13 = alloca %record1
  %14 = alloca %record1
  %15 = bitcast %record1* %3 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %15, i8 0, i64 16, i1 false)
  %16 = bitcast %record1* %4 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %16, i8 0, i64 16, i1 false)
  %17 = bitcast %record1* %5 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %17, i8 0, i64 16, i1 false)
  %18 = bitcast %record1* %6 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %18, i8 0, i64 16, i1 false)
  %19 = bitcast %record1* %7 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %19, i8 0, i64 16, i1 false)
  %20 = bitcast %record2* %10 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %20, i8 0, i64 32, i1 false)
  %21 = bitcast %record2* %11 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %21, i8 0, i64 32, i1 false)
  %22 = bitcast %record1* %12 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %22, i8 0, i64 16, i1 false)
  %23 = bitcast %record1* %13 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %23, i8 0, i64 16, i1 false)
  %24 = bitcast %record1* %14 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %24, i8 0, i64 16, i1 false)
  %25 = alloca i32
  %26 = bitcast %record1* %0 to i8*
  %27 = bitcast %record1* %1 to i8*
  %28 = bitcast %record1* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %26, i8 0, i64 16, i1 false)
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %27, i8 0, i64 16, i1 false)
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %28, i8 0, i64 16, i1 false)
  %29 = addrspacecast %record1* %2 to %record1 addrspace(1)*
  br label %body1

body1:                                       ; preds = %tmpend1, %entry
  %count.03.i = phi i64 [ 1, %entry ], [ %31, %tmpend1 ]
  %30 = and i64 %count.03.i, 1
  %icmpeq.i = icmp eq i64 %30, 0
  br i1 %icmpeq.i, label %tmp1, label %tmp2

; CHECK:  tmp1:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @g0, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %29, i8 addrspace(1)* null, %record1 addrspace(1)* %29) [ "struct-live"(%record1* %0, %record1* %1, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7, %record2* %11, %record1* %2) ]
;
tmp1:                                       ; preds = %body1
  call void @g0(i8 addrspace(1)* null, %record1 addrspace(1)* %29, i8 addrspace(1)* null, %record1 addrspace(1)* %29)
  br label %tmpend1

; CHECK:  tmp2:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @g0, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %29, i8 addrspace(1)* null, %record1 addrspace(1)* %29) [ "struct-live"(%record1* %0, %record1* %1, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7, %record2* %11, %record1* %2) ]
;
tmp2:                                       ; preds = %body1
  call void @g0(i8 addrspace(1)* null, %record1 addrspace(1)* %29, i8 addrspace(1)* null, %record1 addrspace(1)* %29)
  br label %tmpend1

tmpend1:                                    ; preds = %tmp2, %tmp1
  %.sink = phi i8* [ %26, %tmp2 ], [ %27, %tmp1 ]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %28, i8* nonnull align 8 %.sink, i64 16, i1 false)
  %31 = add nuw nsw i64 %count.03.i, 1
  %icmpeq1 = icmp eq i64 %31, 500
  br i1 %icmpeq1, label %body2, label %body1

; CHECK:  body2:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*)* @g1, i32 2, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %32) [ "struct-live"(%record1* %12, %record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7, %record2* %11, %record1* %13) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i8 addrspace(1)* (i8 addrspace(1)*, %record2 addrspace(1)*)* @g2, i32 2, i32 0, i8 addrspace(1)* null, %record2 addrspace(1)* %33) [ "struct-live"(%record1* %12, %record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7, %record2* %10) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i8* (i8 addrspace(1)*)* @g3, i32 1, i32 0, i8 addrspace(1)* %34) [ "gc-live"(i8 addrspace(1)* %34), "struct-live"(%record1* %12, %record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i8* (i64*, i32, i32, i64, i64)* @g4, i32 5, i32 0, i64* %39, i32 10, i32 907, i64 0, i64 0) [ "gc-live"(i8 addrspace(1)* %36), "struct-live"(%record1* %12, %record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7) ]
;
body2:                ; preds = %tmpend1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %24, i8* nonnull align 8 %28, i64 16, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %23, i8* nonnull align 8 %24, i64 16, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %22, i8* nonnull align 8 %.sink, i64 16, i1 false)
  %32 = addrspacecast %record1* %13 to %record1 addrspace(1)*
  call void @g1(i8 addrspace(1)* null, %record1 addrspace(1)* %32)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %20, i8* nonnull align 8 %21, i64 32, i1 false)
  %33 = addrspacecast %record2* %10 to %record2 addrspace(1)*
  %34 = call i8 addrspace(1)* @g2(i8 addrspace(1)* null, %record2 addrspace(1)* %33)
  %35 = call i8* @g3(i8 addrspace(1)* %34)
  %36 = getelementptr inbounds i8, i8* %35, i64 32
  %37 = bitcast i8* %36 to i64**
  %38 = load i64*, i64** %37
  %39 = call i8* @g4(i64* %38, i32 10, i32 907, i64 0, i64 0)
  %40 = bitcast i8* %39 to void (%struct*, i8 addrspace(1)*)*
  %41 = getelementptr inbounds %struct, %struct* %9, i64 0, i32 0
  %42 = load i1, i1* %41
  br i1 %42, label %ifthen1, label %ifelse1

ifthen1:                                     ; preds = %body2
  %.pre = addrspacecast %record1* %12 to %record1 addrspace(1)*
  br label %end

ifelse1:                                  ; preds = %body2
  %43 = getelementptr inbounds %struct, %struct* %9, i64 0, i32 1
  %44 = addrspacecast %record1* %12 to %record1 addrspace(1)*
  %45 = addrspacecast %record1* %7 to %record1 addrspace(1)*
  %46 = addrspacecast %record1* %6 to %record1 addrspace(1)*
  br label %body3

; CHECK:  body3:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i32)* @g5, i32 1, i32 0, i32 %49) [ "gc-live"(i8 addrspace(1)* %.0), "struct-live"(%record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7, %record1* %12) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @g0, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %46, i8 addrspace(1)* null, %record1 addrspace(1)* %47) [ "gc-live"(i8 addrspace(1)* %50), "struct-live"(%record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7, %record1* %12) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @g0, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %48, i8 addrspace(1)* null, %record1 addrspace(1)* %29) [ "gc-live"(i8 addrspace(1)* %51), "struct-live"(%record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i8* (i8 addrspace(1)*)* @g3, i32 1, i32 0, i8 addrspace(1)* %52) [ "gc-live"(i8 addrspace(1)* %52), "struct-live"(%record1* %12, %record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i8* (i64*, i32, i32, i64, i64)* @g4, i32 5, i32 0, i64* %57, i32 10, i32 907, i64 0, i64 0) [ "gc-live"(i8 addrspace(1)* %54), "struct-live"(%record1* %12, %record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %5, %record1* %6, %record1* %7) ]
;
body3:                                        ; preds = %ifelse1, %body3
  %47 = load i32, i32* %43
  call void @g5(i32 %47)
  call void @g0(i8 addrspace(1)* null, %record1 addrspace(1)* %44, i8 addrspace(1)* null, %record1 addrspace(1)* %45)
  call void @g0(i8 addrspace(1)* null, %record1 addrspace(1)* %46, i8 addrspace(1)* null, %record1 addrspace(1)* %29)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 %22, i8* nonnull align 8 %17, i64 16, i1 false)
  %48 = call i8* @g3(i8 addrspace(1)* %34)
  %49 = getelementptr inbounds i8, i8* %48, i64 32
  %50 = bitcast i8* %49 to i64**
  %51 = load i64*, i64** %50
  %52 = call i8* @g4(i64* %51, i32 10, i32 907, i64 0, i64 0)
  %53 = bitcast i8* %52 to void (%struct*, i8 addrspace(1)*)*
  %54 = load i1, i1* %41
  br i1 %54, label %end, label %body3

; CHECK:  end:
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*)* @g6, i32 2, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %.pre-phi) [ "struct-live"(%record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %12) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @g0, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %62, i8 addrspace(1)* null, %record1 addrspace(1)* %29) [ "struct-live"(%record1* %2, %record1* %8, %record1* %3, %record1* %4, %record1* %12) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @g0, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %29, i8 addrspace(1)* null, %record1 addrspace(1)* %63) [ "struct-live"(%record1* %2, %record1* %8, %record1* %3, %record1* %12) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i1 (i8 addrspace(1)*, %record1 addrspace(1)*)* @g9, i32 2, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %64) [ "struct-live"(%record1* %2, %record1* %8, %record1* %12) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record1 addrspace(1)*, i1)* @g7, i32 3, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %64, i1 %65) [ "struct-live"(%record1* %2, %record1* %8, %record1* %12) ]
; CHECK:  [[TOKEN:%.*]] = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, i1 (i8 addrspace(1)*, %record1 addrspace(1)*, i8 addrspace(1)*, %record1 addrspace(1)*)* @g8, i32 4, i32 0, i8 addrspace(1)* null, %record1 addrspace(1)* %.pre-phi, i8 addrspace(1)* null, %record1 addrspace(1)* %29) [ "struct-live"(%record1* %2, %record1* %12) ]
;
end:                                        ; preds = %body3, %ifthen1
  %.pre-phi = phi %record1 addrspace(1)* [ %.pre, %ifthen1 ], [ %44, %body3 ]
  call void @g6(i8 addrspace(1)* null, %record1 addrspace(1)* %.pre-phi)
  %55 = addrspacecast %record1* %4 to %record1 addrspace(1)*
  call void @g0(i8 addrspace(1)* null, %record1 addrspace(1)* %55, i8 addrspace(1)* null, %record1 addrspace(1)* %29)
  %56 = addrspacecast %record1* %3 to %record1 addrspace(1)*
  call void @g0(i8 addrspace(1)* null, %record1 addrspace(1)* %29, i8 addrspace(1)* null, %record1 addrspace(1)* %56)
  %57 = addrspacecast %record1* %8 to %record1 addrspace(1)*
  %58 = call i1 @g9(i8 addrspace(1)* null, %record1 addrspace(1)* %57)
  call void @g7(i8 addrspace(1)* null, %record1 addrspace(1)* %57, i1 %58)
  %59 = call i1 @g8(i8 addrspace(1)* null, %record1 addrspace(1)* %.pre-phi, i8 addrspace(1)* null, %record1 addrspace(1)* %29)
  %not. = xor i1 %59, true
  %spec.select = zext i1 %not. to i64
  ret i64 %spec.select
}

attributes #0 = { "hasRcdParam" }
