; RUN: opt < %s '-passes=cj-pea' -cj-disable-partial-ea -S | FileCheck %s

%"record._ZN11std$FS$time8DurationE" = type { i64 }
%"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE" = type { i8 addrspace(1)*, i64, i64 }
%ArrayLayout.refArray = type { %ArrayBase, [0 x i8 addrspace(1)*] }
%ArrayBase = type { i64 }
%TypeTemplate = type { i8*, i8, i8, i16, i16, i8*, i8*, i8*, i8* }
%TypeInfo = type { i8*, i8, i8, i16, i32, %BitMap*, i32, i8, i8, i32*, i8*, i8*, i8*, %TypeInfo*, i8*, i8* }
%ObjLayout.Object = type {}
%ObjLayout._ZN7default5HumanE = type { %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE", i64, i64 }
%BitMap = type { i32, [0 x i8] }
%Unit.Type = type { i8 }
%"record._ZN11std$FS$core6StringE" = type { %"record._ZN7default11std$FS$core5ArrayIhE", i64 }
%"record._ZN7default11std$FS$core5ArrayIhE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN11std$FS$time8DateTimeE" = type { i32, i32, i64, i64, i8 addrspace(1)*, i64 }
%ArrayLayout.UInt8 = type { %ArrayBase, [0 x i8] }
%ObjLayout._ZN7default8testZlibE = type { %"ObjLayout._ZN15std$FS$unittest9TestCasesE", i1, %"record._ZN7default11std$FS$core5ArrayIhE", i8 addrspace(1)*, i8 addrspace(1)*, i64, i64, i64 }
%"ObjLayout._ZN15std$FS$unittest9TestCasesE" = type { %"ObjLayout._ZN15std$FS$unittest5UTestE", i8 addrspace(1)*, i1, i1 }
%"ObjLayout._ZN15std$FS$unittest5UTestE" = type { i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" }

@"$const_cjstring.7" = internal constant { { i8 addrspace(1)*, i64, i64 }, i64 } { { i8 addrspace(1)*, i64, i64 } { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [504 x i8] }* @"$const_cjstring_data.0" to i8*) to i8 addrspace(1)*), i64 210, i64 8 }, i64 0 }
@"$const_cjstring.5" = internal constant { { i8 addrspace(1)*, i64, i64 }, i64 } { { i8 addrspace(1)*, i64, i64 } { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [504 x i8] }* @"$const_cjstring_data.0" to i8*) to i8 addrspace(1)*), i64 126, i64 3 }, i64 0 }
@"$const_cjstring_data.0" = internal constant { i8*, i64, [504 x i8] } { i8* bitcast (%TypeInfo* @roUInt8.arrayKlass to i8*), i64 504, [504 x i8] c"], [mulindex: .Illegal step Overshift: Negative shift count!invalid size of ArrayList: invalid capacity of ArrayList: typecastadd, step should be 1outputthe value of the step should not be zero.\0Asubtest, size: testZlib is not equal to array size:Casting NaN value to integer.Negative copy lengthOvershift: Value of right operand is greater than or equal to the width of left operand!Array negative index accessdiv, length is Range size:noneThe size of Array is , start is inputCopy length out of bounds[]" }
@array_int8.uniqueAddr = weak_odr hidden global i64 0
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" = external global %TypeInfo
@"_ZN11std$FS$time8TimeZone5LocalE" = external local_unnamed_addr global i8 addrspace(1)*
@roUInt8.arrayKlass = weak_odr global %TypeInfo { i8* getelementptr inbounds ([16 x i8], [16 x i8]* @"RawArray<UInt8>.name", i32 0, i32 0), i8 -126, i8 0, i16 0, i32 0, %BitMap* null, i32 0, i8 0, i8 0, i32* null, i8* bitcast (%TypeTemplate* @RawArray.tt to i8*), i8* null, i8* null, %TypeInfo* @UInt8.ti, i8* null, i8* null }
@"RawArray<UInt8>.name" = internal global [16 x i8] c"RawArray<UInt8>\00", align 1
@UInt8.ti = external global %TypeInfo
@"std.core$Object.ti" = external global %TypeInfo
@_ZN7default5HumanE.ti = weak_odr global %TypeInfo {i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"default$Human.name", i32 0, i32 0), i8 -128, i8 0, i16 2, i32 16, %BitMap* null, i32 0, i8 8, i8 0, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @"default$Human.ti.offsets", i32 0, i32 0), i8* null, i8* null, i8* bitcast ([1 x %TypeInfo*]* @"default$Human.ti.fields" to i8*), %TypeInfo* @"std.core$Object.ti", i8* null, i8* bitcast ([1 x i8*]* @"default$Human.fieldNames" to i8*)}, !RelatedType !1
@"default$Human.name" = internal global [14 x i8] c"default$Human\00", align 1
@"default$Human.ti.offsets" = internal global [1 x i32] [i32 0]
@"default$Human.ti.fields" = internal global [1 x %TypeInfo*] [%TypeInfo* @"std.core$Object.ti"]
@"default$Human.fieldNames" = internal global [1 x i8*] [i8* getelementptr inbounds ([3 x i8], [3 x i8]* @"default$Human.field.1.name", i32 0, i32 0)]
@"default$Human.field.1.name" = internal global [3 x i8] c"aa\00", align 1
@"RawArray<Obj>.ti" = internal global %TypeInfo { i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"RawArray<Obj>.name", i32 0, i32 0), i8 -126, i8 0, i16 0, i32 8, %BitMap* null, i32 0, i8 8, i8 0, i32* null, i8* bitcast (%TypeTemplate* @RawArray.tt to i8*), i8* null, i8* null, %TypeInfo* @"std.core$Object.ti", i8* null, i8* null }, !RelatedType !0
@"RawArray<Obj>.name" = internal global [14 x i8] c"RawArray<Obj>\00"
@RawArray.tt = external global %TypeTemplate

declare i8* @CJ_MCC_GetObjClass(i8 addrspace(1)*)
declare i8 addrspace(1)* @CJ_MCC_NewArray(i8*, i64)
declare i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32)
declare void @CJ_MCC_ThrowException(i8 addrspace(1)*)
declare void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)*)
declare void @"_ZN11std$FS$time8DateTime1-ER_ZN11std$FS$time8DateTimeE"(%"record._ZN11std$FS$time8DurationE"*, i8 addrspace(1)*, %"record._ZN11std$FS$time8DateTimeE" addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$time8DateTimeE" addrspace(1)*)
declare void @"_ZN11std$FS$time8DateTime3nowEC_ZN11std$FS$time8TimeZoneE"(%"record._ZN11std$FS$time8DateTimeE"*, i8 addrspace(1)*)
declare void @"_ZN15std$FS$unittest8TestInfo11printResultEv"(%Unit.Type*, i8 addrspace(1)*)
declare i8 addrspace(1)* @"_ZN7default11std$FS$core13ArrayIteratorIC_ZN7default8testZlibE4nextEv"(i8 addrspace(1)*)
declare i8 addrspace(1)* @"_ZN7default11std$FS$core13ArrayIteratorIC_ZN7default8testZlibE8iteratorEv"(i8 addrspace(1)*)
declare void @"_ZN15std$FS$unittest9TestCases8runCasesEv"(%Unit.Type*, i8 addrspace(1)*)
declare i8 addrspace(1)* @"_ZN15std$FS$unittest5UTest10jsonReportEv"(i8 addrspace(1)*)
declare i8 addrspace(1)* @"_ZN15std$FS$unittest5UTest11getTestInfoEv"(i8 addrspace(1)*)
declare i8 addrspace(1)* @"_ZN15std$FS$unittest5UTest7$ctxgetEv"(i8 addrspace(1)*)
declare void @_ZN7default8testZlib9initCasesEv(%Unit.Type*, i8 addrspace(1)*)
declare void @"_ZN15std$FS$unittest9TestCases8afterAllEv"(%Unit.Type*, i8 addrspace(1)*)
declare void @"_ZN15std$FS$unittest9TestCases9afterEachEv"(%Unit.Type*, i8 addrspace(1)*)
declare void @"_ZN15std$FS$unittest9TestCases9beforeAllEv"(%Unit.Type*, i8 addrspace(1)*)
declare void @"_ZN15std$FS$unittest9TestCases10beforeEachEv"(%Unit.Type*, i8 addrspace(1)*)
declare void @_ZN7default8testZlib4testEv(%Unit.Type*, i8 addrspace(1)*)
declare void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)*, i8 addrspace(1)*, i8*, i64)
declare void @llvm.cj.gcwrite.ref(i8 addrspace(1)*, i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)*)
declare void @llvm.cj.memset.p0i8(i8*, i8, i64, i1)
declare void @llvm.lifetime.end.p0i8(i64, i8*)
declare void @llvm.lifetime.start.p0i8(i64, i8*)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64)
declare i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*)
declare void @"_ZN11std$FS$core26NegativeArraySizeException6<init>Ev"(i8 addrspace(1)*)
declare void @"_ZN15std$FS$unittest9TestCases6<init>Ev"(i8 addrspace(1)*)
declare void @"_ZN9std$FS$io15ByteBuffer5writeER_ZN11std$FS$core5ArrayIhE"(%Unit.Type*, i8 addrspace(1)*, i8 addrspace(1)*, %"record._ZN7default11std$FS$core5ArrayIhE" addrspace(1)*)
declare void @"_ZN9std$FS$io15ByteBuffer6<init>El"(i8 addrspace(1)*, i64)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
declare void @foo1(i8 addrspace(1)* %this, i64 %len, i64 %wrap, i64 %compressLevel, i64 %bufLen)

; CHECK: alloca { %TypeInfo*, { %ArrayBase, [18 x i8 addrspace(1)*] } }

define i64 @"_ZN7default6<main>Ev"() local_unnamed_addr gc "cangjie" {
entry:
  %callRet7.i = alloca %"record._ZN11std$FS$time8DurationE", align 8
  %callRet6.i = alloca %"record._ZN11std$FS$time8DateTimeE", align 8
  %callRet3.i = alloca %Unit.Type, align 8
  %callRet.i = alloca %"record._ZN11std$FS$time8DateTimeE", align 8
  %callRet29 = alloca %Unit.Type, align 8
  %cases = alloca %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE", align 8
  %0 = call noalias i8 addrspace(1)* @CJ_MCC_NewArray(i8* bitcast (%TypeInfo* @"RawArray<Obj>.ti" to i8*), i64 18)
  %1 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %1, i64 1024, i64 0, i64 0, i64 1)
  %arr.idx0E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 16
  %2 = bitcast i8 addrspace(1)* %arr.idx0E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %1, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %2)
  %3 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %3, i64 1024, i64 0, i64 1, i64 1)
  %arr.idx1E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 24
  %4 = bitcast i8 addrspace(1)* %arr.idx1E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %3, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %4)
  %5 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %5, i64 1024, i64 0, i64 2, i64 1)
  %arr.idx2E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 32
  %6 = bitcast i8 addrspace(1)* %arr.idx2E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %5, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %6)
  %7 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %7, i64 1, i64 0, i64 0, i64 1024)
  %arr.idx3E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 40
  %8 = bitcast i8 addrspace(1)* %arr.idx3E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %7, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %8)
  %9 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %9, i64 1024, i64 0, i64 1, i64 1024)
  %arr.idx4E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 48
  %10 = bitcast i8 addrspace(1)* %arr.idx4E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %9, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %10)
  %11 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %11, i64 1024, i64 0, i64 2, i64 1024)
  %arr.idx5E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 56
  %12 = bitcast i8 addrspace(1)* %arr.idx5E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %11, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %12)
  %13 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %13, i64 1024, i64 0, i64 0, i64 1048576)
  %arr.idx6E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 64
  %14 = bitcast i8 addrspace(1)* %arr.idx6E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %13, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %14)
  %15 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %15, i64 1, i64 0, i64 1, i64 1048576)
  %arr.idx7E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 72
  %16 = bitcast i8 addrspace(1)* %arr.idx7E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %15, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %16)
  %17 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %17, i64 1024, i64 0, i64 2, i64 1048576)
  %arr.idx8E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 80
  %18 = bitcast i8 addrspace(1)* %arr.idx8E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %17, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %18)
  %19 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %19, i64 1024, i64 1, i64 0, i64 1)
  %arr.idx9E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 88
  %20 = bitcast i8 addrspace(1)* %arr.idx9E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %19, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %20)
  %21 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %21, i64 1024, i64 1, i64 1, i64 1)
  %arr.idx10E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 96
  %22 = bitcast i8 addrspace(1)* %arr.idx10E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %21, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %22)
  %23 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %23, i64 1, i64 1, i64 2, i64 1)
  %arr.idx11E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 104
  %24 = bitcast i8 addrspace(1)* %arr.idx11E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %23, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %24)
  %25 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %25, i64 1024, i64 1, i64 0, i64 1024)
  %arr.idx12E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 112
  %26 = bitcast i8 addrspace(1)* %arr.idx12E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %25, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %26)
  %27 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %27, i64 1048576, i64 1, i64 1, i64 1024)
  %arr.idx13E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 120
  %28 = bitcast i8 addrspace(1)* %arr.idx13E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %27, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %28)
  %29 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %29, i64 1024, i64 1, i64 2, i64 1024)
  %arr.idx14E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 128
  %30 = bitcast i8 addrspace(1)* %arr.idx14E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %29, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %30)
  %31 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %31, i64 1024, i64 1, i64 0, i64 1048576)
  %arr.idx15E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 136
  %32 = bitcast i8 addrspace(1)* %arr.idx15E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %31, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %32)
  %33 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %33, i64 1024, i64 1, i64 1, i64 1048576)
  %arr.idx16E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 144
  %34 = bitcast i8 addrspace(1)* %arr.idx16E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %33, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %34)
  %35 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 144)
  call void @foo1(i8 addrspace(1)* %35, i64 1048576, i64 1, i64 2, i64 1048576)
  %arr.idx17E = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 152
  %36 = bitcast i8 addrspace(1)* %arr.idx17E to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %35, i8 addrspace(1)* %0, i8 addrspace(1)* addrspace(1)* %36)
  %37 = bitcast %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE"* %cases to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %37, i8 0, i64 24, i1 false)
  %atom.sroa.0.0..sroa_idx1 = getelementptr inbounds %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE", %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE"* %cases, i64 0, i32 0
  store i8 addrspace(1)* %0, i8 addrspace(1)** %atom.sroa.0.0..sroa_idx1, align 8
  %atom.sroa.4.0..sroa_idx4 = getelementptr inbounds %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE", %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE"* %cases, i64 0, i32 1
  store i64 0, i64* %atom.sroa.4.0..sroa_idx4, align 8
  %atom.sroa.5.0..sroa_idx7 = getelementptr inbounds %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE", %"record._ZN7default11std$FS$core5ArrayIC_ZN7default8testZlibEE"* %cases, i64 0, i32 2
  store i64 18, i64* %atom.sroa.5.0..sroa_idx7, align 8
  %38 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 48)
  %39 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 8
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %38, i8 addrspace(1)* %39, i8* nonnull %37, i64 24)
  %40 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 32
  %41 = bitcast i8 addrspace(1)* %40 to i64 addrspace(1)*
  store i64 18, i64 addrspace(1)* %41, align 8
  %42 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 40
  %43 = bitcast i8 addrspace(1)* %42 to i64 addrspace(1)*
  store i64 0, i64 addrspace(1)* %43, align 8
  br label %block.body

block.body:                                       ; preds = %normal34, %entry
  %atom22.0 = phi i64 [ 0, %entry ], [ %.fca.0.extract34, %normal34 ]
  %44 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 40
  %45 = bitcast i8 addrspace(1)* %44 to i64 addrspace(1)*
  %46 = load i64, i64 addrspace(1)* %45, align 8
  %47 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 32
  %48 = bitcast i8 addrspace(1)* %47 to i64 addrspace(1)*
  %49 = load i64, i64 addrspace(1)* %48, align 8
  %icmpslt.i = icmp slt i64 %46, %49
  br i1 %icmpslt.i, label %if.then.i, label %"_ZN7default11std$FS$core13ArrayIteratorIC_ZN7default8testZlibE4nextEv.exit"

if.then.i:                                        ; preds = %block.body
  %50 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 24
  %51 = bitcast i8 addrspace(1)* %50 to i64 addrspace(1)*
  %52 = load i64, i64 addrspace(1)* %51, align 8
  %icmpuge.not.i = icmp ult i64 %46, %52
  br i1 %icmpuge.not.i, label %if.else5.i, label %if.then6.i

if.then6.i:                                       ; preds = %if.then.i
  %53 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @_ZN7default5HumanE.ti to i8*), i32 72)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException6<init>Ev"(i8 addrspace(1)* %53)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %53)
  unreachable

if.else5.i:                                       ; preds = %if.then.i
  %54 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 8
  %55 = bitcast i8 addrspace(1)* %54 to %ArrayLayout.refArray addrspace(1)* addrspace(1)*
  %56 = load %ArrayLayout.refArray addrspace(1)*, %ArrayLayout.refArray addrspace(1)* addrspace(1)* %55, align 8
  %57 = getelementptr inbounds i8, i8 addrspace(1)* %38, i64 16
  %58 = bitcast i8 addrspace(1)* %57 to i64 addrspace(1)*
  %59 = load i64, i64 addrspace(1)* %58, align 8
  %add.i = add i64 %59, %46
  %arr.idx.get.gep.i = getelementptr inbounds %ArrayLayout.refArray, %ArrayLayout.refArray addrspace(1)* %56, i64 0, i32 1, i64 %add.i
  %60 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arr.idx.get.gep.i, align 8
  %add8.i = add nuw i64 %46, 1
  store i64 %add8.i, i64 addrspace(1)* %45, align 8
  br label %"_ZN7default11std$FS$core13ArrayIteratorIC_ZN7default8testZlibE4nextEv.exit"

"_ZN7default11std$FS$core13ArrayIteratorIC_ZN7default8testZlibE4nextEv.exit": ; preds = %block.body, %if.else5.i
  %common.ret.op.i = phi i8 addrspace(1)* [ %60, %if.else5.i ], [ null, %block.body ]
  %61 = icmp eq i8 addrspace(1)* %common.ret.op.i, null
  br i1 %61, label %if.then, label %if.else

if.then:                                          ; preds = %"_ZN7default11std$FS$core13ArrayIteratorIC_ZN7default8testZlibE4nextEv.exit"
  ret i64 %atom22.0

if.else:                                          ; preds = %"_ZN7default11std$FS$core13ArrayIteratorIC_ZN7default8testZlibE4nextEv.exit"
  %62 = bitcast %"record._ZN11std$FS$time8DurationE"* %callRet7.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %62)
  %63 = bitcast %"record._ZN11std$FS$time8DateTimeE"* %callRet6.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %63)
  %64 = getelementptr inbounds %Unit.Type, %Unit.Type* %callRet3.i, i64 0, i32 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %64)
  %65 = bitcast %"record._ZN11std$FS$time8DateTimeE"* %callRet.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %65)
  %66 = getelementptr inbounds i8, i8 addrspace(1)* %common.ret.op.i, i64 16
  %67 = bitcast i8 addrspace(1)* %66 to i8 addrspace(1)* addrspace(1)*
  %68 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %67, align 8
  %69 = load i8 addrspace(1)*, i8 addrspace(1)** @"_ZN11std$FS$time8TimeZone5LocalE", align 8
  %70 = bitcast %"record._ZN11std$FS$time8DateTimeE"* %callRet.i to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %70, i8 0, i64 40, i1 false)
  call void @"_ZN11std$FS$time8DateTime3nowEC_ZN11std$FS$time8TimeZoneE"(%"record._ZN11std$FS$time8DateTimeE"* noalias nonnull sret(%"record._ZN11std$FS$time8DateTimeE") %callRet.i, i8 addrspace(1)* %69)
  %71 = getelementptr inbounds i8, i8 addrspace(1)* %68, i64 96
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %68, i8 addrspace(1)* %71, i8* nonnull %70, i64 40)
  %72 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %67, align 8
  %73 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* nonnull %common.ret.op.i)
  %74 = getelementptr i8, i8* %73, i64 24
  %75 = bitcast i8* %74 to i8***
  %76 = load i8**, i8*** %75, align 8
  %77 = getelementptr i8*, i8** %76, i64 4
  %78 = bitcast i8** %77 to i8 addrspace(1)* (i8 addrspace(1)*)**
  %79 = load i8 addrspace(1)* (i8 addrspace(1)*)*, i8 addrspace(1)* (i8 addrspace(1)*)** %78, align 8
  %80 = call i8 addrspace(1)* %79(i8 addrspace(1)* nonnull %common.ret.op.i)
  %81 = getelementptr inbounds i8, i8 addrspace(1)* %80, i64 8
  %82 = bitcast i8 addrspace(1)* %81 to i8 addrspace(1)* addrspace(1)*
  call void @llvm.cj.gcwrite.ref(i8 addrspace(1)* %72, i8 addrspace(1)* %80, i8 addrspace(1)* addrspace(1)* %82)
  %83 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* nonnull %common.ret.op.i)
  %84 = getelementptr i8, i8* %83, i64 24
  %85 = bitcast i8* %84 to i8***
  %86 = load i8**, i8*** %85, align 8
  %87 = getelementptr i8*, i8** %86, i64 1
  %88 = bitcast i8** %87 to void (%Unit.Type*, i8 addrspace(1)*)**
  %89 = load void (%Unit.Type*, i8 addrspace(1)*)*, void (%Unit.Type*, i8 addrspace(1)*)** %88, align 8
  call void %89(%Unit.Type* noalias nonnull sret(%Unit.Type) %callRet3.i, i8 addrspace(1)* nonnull %common.ret.op.i)
  %90 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %67, align 8
  %91 = load i8 addrspace(1)*, i8 addrspace(1)** @"_ZN11std$FS$time8TimeZone5LocalE", align 8
  %92 = bitcast %"record._ZN11std$FS$time8DateTimeE"* %callRet6.i to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %92, i8 0, i64 40, i1 false)
  call void @"_ZN11std$FS$time8DateTime3nowEC_ZN11std$FS$time8TimeZoneE"(%"record._ZN11std$FS$time8DateTimeE"* noalias nonnull sret(%"record._ZN11std$FS$time8DateTimeE") %callRet6.i, i8 addrspace(1)* %91)
  %93 = getelementptr inbounds i8, i8 addrspace(1)* %90, i64 96
  %94 = bitcast i8 addrspace(1)* %93 to %"record._ZN11std$FS$time8DateTimeE" addrspace(1)*
  %95 = addrspacecast %"record._ZN11std$FS$time8DateTimeE"* %callRet6.i to %"record._ZN11std$FS$time8DateTimeE" addrspace(1)*
  call void @"_ZN11std$FS$time8DateTime1-ER_ZN11std$FS$time8DateTimeE"(%"record._ZN11std$FS$time8DurationE"* noalias nonnull sret(%"record._ZN11std$FS$time8DurationE") %callRet7.i, i8 addrspace(1)* null, %"record._ZN11std$FS$time8DateTimeE" addrspace(1)* %95, i8 addrspace(1)* %90, %"record._ZN11std$FS$time8DateTimeE" addrspace(1)* %94)
  %96 = getelementptr inbounds %"record._ZN11std$FS$time8DurationE", %"record._ZN11std$FS$time8DurationE"* %callRet7.i, i64 0, i32 0
  %97 = load i64, i64* %96, align 8
  %98 = getelementptr inbounds i8, i8 addrspace(1)* %90, i64 136
  %99 = bitcast i8 addrspace(1)* %98 to i64 addrspace(1)*
  store i64 %97, i64 addrspace(1)* %99, align 8
  %100 = bitcast %"record._ZN11std$FS$time8DurationE"* %callRet7.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %100)
  %101 = bitcast %"record._ZN11std$FS$time8DateTimeE"* %callRet6.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %101)
  %102 = getelementptr inbounds %Unit.Type, %Unit.Type* %callRet3.i, i64 0, i32 0
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %102)
  %103 = bitcast %"record._ZN11std$FS$time8DateTimeE"* %callRet.i to i8*
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %103)
  %104 = getelementptr inbounds i8, i8 addrspace(1)* %common.ret.op.i, i64 16
  %105 = bitcast i8 addrspace(1)* %104 to i8 addrspace(1)* addrspace(1)*
  %106 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %105, align 8
  call void @"_ZN15std$FS$unittest8TestInfo11printResultEv"(%Unit.Type* noalias nonnull sret(%Unit.Type) %callRet29, i8 addrspace(1)* %106)
  %107 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* nonnull %common.ret.op.i)
  %108 = getelementptr i8, i8* %107, i64 24
  %109 = bitcast i8* %108 to i8***
  %110 = load i8**, i8*** %109, align 8
  %111 = getelementptr i8*, i8** %110, i64 3
  %112 = bitcast i8** %111 to i8 addrspace(1)* (i8 addrspace(1)*)**
  %113 = load i8 addrspace(1)* (i8 addrspace(1)*)*, i8 addrspace(1)* (i8 addrspace(1)*)** %112, align 8
  %114 = call i8 addrspace(1)* %113(i8 addrspace(1)* nonnull %common.ret.op.i)
  %115 = getelementptr inbounds i8, i8 addrspace(1)* %114, i64 72
  %116 = bitcast i8 addrspace(1)* %115 to i64 addrspace(1)*
  %117 = load i64, i64 addrspace(1)* %116, align 8
  %118 = getelementptr inbounds i8, i8 addrspace(1)* %114, i64 48
  %119 = bitcast i8 addrspace(1)* %118 to i64 addrspace(1)*
  %120 = load i64, i64 addrspace(1)* %119, align 8
  %121 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %117, i64 %120)
  %.fca.1.extract = extractvalue { i64, i1 } %121, 1
  br i1 %.fca.1.extract, label %overflow, label %normal

normal:                                           ; preds = %if.else
  %.fca.0.extract = extractvalue { i64, i1 } %121, 0
  %122 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %atom22.0, i64 %.fca.0.extract)
  %.fca.1.extract35 = extractvalue { i64, i1 } %122, 1
  br i1 %.fca.1.extract35, label %overflow33, label %normal34

overflow:                                         ; preds = %if.else
  %123 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* bitcast ({ { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.5" to %"record._ZN11std$FS$core6StringE"*) to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %123)
  unreachable

normal34:                                         ; preds = %normal
  %.fca.0.extract34 = extractvalue { i64, i1 } %122, 0
  br label %block.body

overflow33:                                       ; preds = %normal
  %124 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* bitcast ({ { i8 addrspace(1)*, i64, i64 }, i64 }* @"$const_cjstring.5" to %"record._ZN11std$FS$core6StringE"*) to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %124)
  unreachable
}

!0 = !{!"ArrayLayout.refArray"}
!1 = !{!"ObjLayout._ZN7default5HumanE"}
