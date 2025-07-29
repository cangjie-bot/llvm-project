; RUN: opt --cj-barrier-opt -enable-new-pm=false -S < %s | FileCheck %s
; RUN: opt -passes=cj-barrier-opt -S < %s | FileCheck %s

%BitMap = type { i32, [0 x i8] }
%KlassInfo.0 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [0 x i8*] }
%Unit.Type = type { i8 }
%ArrayLayout.Unit = type { %ArrayBase, [0 x %Unit.Type] }
%ArrayBase = type { %ObjLayout.Object, i64 }
%ObjLayout.Object = type { %KlassInfo.0* }
%"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN7default11std$FS$core5ArrayIuE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN7default11std$FS$core5RangeIjE" = type { i32, i32, i64, i1, i1, i1 }
%"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE" = type { [1 x %Unit.Type], %"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE", double, %"record._ZN7default11std$FS$core5ArrayIuE", %"record._ZN7default11std$FS$core5RangeIjE" }

@Unit.Val = weak_odr global %Unit.Type zeroinitializer
@A1_uE.className = weak_odr global [6 x i8] c"A1_uE\00", align 1
@Unit.arrayKlass = weak_odr global %KlassInfo.0 { i32 2, i32 1, %BitMap* null, i8* bitcast (%KlassInfo.0* @Unit.Type.structKlass to i8*), i8** null, i64* null, i64* null, i64* bitcast ([6 x i8]* @A1_uE.className to i64*), i32 0, [0 x i8*] zeroinitializer }
@Unit.Type.structKlass = weak_odr global %KlassInfo.0 { i32 8, i32 1, %BitMap* inttoptr (i64 -9223372036854775808 to %BitMap*), i8* null, i8** null, i64* null, i64* null, i64* @Unit.Type.uniqueAddr, i32 0, [0 x i8*] zeroinitializer }
@Unit.Type.uniqueAddr = weak_odr global i64 0
@_ZN7default22var_1691532726212_1148E = global %"record._ZN7default11std$FS$core5RangeIjE" zeroinitializer

declare i8 addrspace(1)* @CJ_MCC_NewArrayStub(i64 %0, i8* %1)
declare void @"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE.create"(%"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE"* noalias sret(%"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE"), i8 addrspace(1)*, [1 x %Unit.Type] addrspace(1)*, i8 addrspace(1)*, %"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE" addrspace(1)*, double, i8 addrspace(1)*, %"record._ZN7default11std$FS$core5ArrayIuE" addrspace(1)*, i8 addrspace(1)*, %"record._ZN7default11std$FS$core5RangeIjE" addrspace(1)*)
declare void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)*, i8 addrspace(1)*, i8*, i64)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

; CHECK: store i8 18, i8 addrspace(1)* %15, align 1

define void @foo(i8 addrspace(1)* %this) gc "cangjie" {
entry:
  %0 = alloca %"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE", align 8
  %1 = alloca %"record._ZN7default11std$FS$core5ArrayIuE", align 8
  %2 = alloca %"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE", align 8
  %3 = alloca [1 x %Unit.Type], align 8
  %4 = alloca [1 x %Unit.Type], align 8
  %5 = getelementptr inbounds [1 x %Unit.Type], [1 x %Unit.Type]* %4, i64 0, i64 0
  %6 = load %Unit.Type, %Unit.Type* @Unit.Val, align 1
  store %Unit.Type %6, %Unit.Type* %5, align 1
  %7 = bitcast [1 x %Unit.Type]* %3 to i8*
  %8 = bitcast [1 x %Unit.Type]* %4 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %7, i8* align 1 %8, i64 1, i1 false)
  %9 = call noalias i8 addrspace(1)* @CJ_MCC_NewArrayStub(i64 10, i8* bitcast (%KlassInfo.0* @Unit.arrayKlass to i8*))
  %10 = bitcast i8 addrspace(1)* %this to %ArrayLayout.Unit addrspace(1)*
  %11 = getelementptr inbounds %ArrayLayout.Unit, %ArrayLayout.Unit addrspace(1)* %10, i32 0, i32 1, i32 0
  %12 = bitcast %Unit.Type addrspace(1)* %11 to i8 addrspace(1)*
  %13 = getelementptr inbounds %Unit.Type, %Unit.Type addrspace(1)* %11, i32 0, i32 0
  store i8 30, i8 addrspace(1)* %13, align 1
  %14 = getelementptr inbounds %Unit.Type, %Unit.Type addrspace(1)* %11, i64 1
  %15 = getelementptr inbounds %Unit.Type, %Unit.Type addrspace(1)* %14, i32 0, i32 0
  store i8 18, i8 addrspace(1)* %15, align 1
  %16 = getelementptr inbounds %Unit.Type, %Unit.Type addrspace(1)* %14, i64 1
  %17 = getelementptr inbounds %Unit.Type, %Unit.Type addrspace(1)* %16, i32 0, i32 0
  store i8 22, i8 addrspace(1)* %17, align 1
  %18 = bitcast %"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE"* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %18, i8 0, i64 24, i1 false)
  %19 = bitcast %"record._ZN7default11std$FS$core5ArrayIuE"* %1 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %19, i8 0, i64 24, i1 false)
  %20 = addrspacecast [1 x %Unit.Type]* %3 to [1 x %Unit.Type] addrspace(1)*
  %21 = addrspacecast %"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE"* %2 to %"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE" addrspace(1)*
  %22 = addrspacecast %"record._ZN7default11std$FS$core5ArrayIuE"* %1 to %"record._ZN7default11std$FS$core5ArrayIuE" addrspace(1)*
  %23 = bitcast %"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE"* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %23, i8 0, i64 88, i1 false)
  call void @"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE.create"(%"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE"* noalias sret(%"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE") %0, i8 addrspace(1)* null, [1 x %Unit.Type] addrspace(1)* %20, i8 addrspace(1)* null, %"record._ZN7default11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEE" addrspace(1)* %21, double 1.200000e+01, i8 addrspace(1)* null, %"record._ZN7default11std$FS$core5ArrayIuE" addrspace(1)* %22, i8 addrspace(1)* null, %"record._ZN7default11std$FS$core5RangeIjE" addrspace(1)* addrspacecast (%"record._ZN7default11std$FS$core5RangeIjE"* @_ZN7default22var_1691532726212_1148E to %"record._ZN7default11std$FS$core5RangeIjE" addrspace(1)*))
  %24 = getelementptr inbounds %"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE", %"T5_V1_uER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core5ArrayImEEdR_ZN11std$FS$core5ArrayIuER_ZN11std$FS$core5RangeIjEE"* %0, i32 0, i32 0
  %25 = getelementptr [1 x %Unit.Type], [1 x %Unit.Type]* %24, i64 0, i64 0
  %26 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %27 = bitcast %Unit.Type* %25 to i8*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %this, i8 addrspace(1)* %26, i8* %27, i64 1)
  ret void
}
