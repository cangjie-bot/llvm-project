%KlassInfo.1 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [1 x i8*] }
%BitMap = type { i32, [0 x i8] }
%KlassInfo.0 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [0 x i8*] }
%"record._ZN11std$FS$core6StringE" = type { i8 addrspace(1)*, i64 }
%"record._ZN17std$FS$collection11std$FS$core5ArrayIcE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN11std$FS$core8Utf8ViewE" = type { %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" }
%Unit.Type = type { i8 }
%T2_clE = type { i32, i64 }
%ArrayLayout.Char = type { %ArrayBase, [0 x i32] }
%ArrayBase = type { %ObjLayout.Object, i64 }
%ObjLayout.Object = type { %KlassInfo.0* }
%"record._ZN17std$FS$collection11std$FS$core6OptionIcE" = type { i1, i32 }
%"ArrayLayout._ZN11std$FS$core6StringE" = type { %ArrayBase, [0 x %"record._ZN11std$FS$core6StringE"] }

@"$const_string.29" = private unnamed_addr constant [4 x i8] c"add\00", align 1
@"$const_string.30" = private unnamed_addr constant [4 x i8] c"mul\00", align 1
@"$const_string.33" = private unnamed_addr constant [11 x i8] c"iterator$0\00", align 1
@"$const_string.34" = private unnamed_addr constant [7 x i8] c"next$0\00", align 1
@"$const_string.35" = private unnamed_addr constant [11 x i8] c"$sizeget$0\00", align 1
@Char.arrayKlass = weak_odr global %KlassInfo.0 { i32 2, i32 4, %BitMap* null, i8* bitcast (%KlassInfo.0* @array_char.primKlass to i8*), i8** null, i64* null, i64* null, i64* bitcast ([6 x i8]* @A1_cE.className to i64*), i32 0, [0 x i8*] zeroinitializer }
@A1_cE.className = weak_odr global [6 x i8] c"A1_cE\00", align 1
@array_char.primKlass = weak_odr global %KlassInfo.0 { i32 1, i32 4, %BitMap* null, i8* null, i8** null, i64* null, i64* null, i64* @array_char.uniqueAddr, i32 0, [0 x i8*] zeroinitializer }
@array_char.uniqueAddr = weak_odr global i64 0
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" = external global %KlassInfo.0
@"_ZN11std$FS$core26NegativeArraySizeExceptionE.objKlass" = external global %KlassInfo.0
@"_ZN11std$FS$core6String5emptyE" = external global %"record._ZN11std$FS$core6StringE"
@"_ZN11std$FS$core6StringE.arrayKlass" = weak_odr global %KlassInfo.0 { i32 34, i32 16, %BitMap* null, i8* bitcast (%KlassInfo.0* @"record._ZN11std$FS$core6StringE.structKlass" to i8*), i8** null, i64* null, i64* null, i64* bitcast ([30 x i8]* @"A1_R_ZN11std$FS$core6StringEE.className" to i64*), i32 0, [0 x i8*] zeroinitializer }
@"A1_R_ZN11std$FS$core6StringEE.className" = weak_odr global [30 x i8] c"A1_R_ZN11std$FS$core6StringEE\00", align 1
@"record._ZN11std$FS$core6StringE.structKlass" = weak_odr global %KlassInfo.0 { i32 40, i32 16, %BitMap* inttoptr (i64 -9223372036854775807 to %BitMap*), i8* null, i8** null, i64* null, i64* null, i64* @"record._ZN11std$FS$core6StringE.uniqueAddr", i32 0, [0 x i8*] zeroinitializer }
@"record._ZN11std$FS$core6StringE.uniqueAddr" = weak_odr global i64 0
@"_ZN15std$$collection22$__STRING_LITERAL__$22E" = internal global %"record._ZN11std$FS$core6StringE" zeroinitializer
@"_ZN15std$$collection22$__STRING_LITERAL__$23E" = internal global %"record._ZN11std$FS$core6StringE" zeroinitializer
@"_ZN15std$$collection22$__STRING_LITERAL__$24E" = internal global %"record._ZN11std$FS$core6StringE" zeroinitializer
@"_ZN15std$$collection22$__STRING_LITERAL__$25E" = internal global %"record._ZN11std$FS$core6StringE" zeroinitializer

declare i8* @CJ_MCC_GetFuncPtrFromItab(i64*, i32, i32, i8*) local_unnamed_addr
declare i8* @CJ_MCC_GetObjClass(i8 addrspace(1)*) local_unnamed_addr
declare i8 addrspace(1)* @CJ_MCC_NewArray32Stub(i64, i8*)
declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)
declare i8 addrspace(1)* @CJ_MCC_NewArrayStub(i64, i8*)
declare void @CJ_MCC_ThrowException(i8 addrspace(1)*) local_unnamed_addr
declare void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)*) local_unnamed_addr gc "cangjie"
declare void @"_ZN11std$FS$core26NegativeArraySizeException4initEv"(i8 addrspace(1)*) local_unnamed_addr gc "cangjie"
declare void @"_ZN11std$FS$core6Extend4Char8fromUtf8ER_ZN11std$FS$core5ArrayIhEl"(%T2_clE* noalias sret(%T2_clE), i8 addrspace(1)*, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)*, i64) local_unnamed_addr gc "cangjie"
declare void @"_ZN11std$FS$core6Extend4Char8toStringEv"(%"record._ZN11std$FS$core6StringE"* noalias sret(%"record._ZN11std$FS$core6StringE"), i32) local_unnamed_addr gc "cangjie"
declare i64 @"_ZN11std$FS$core6Extend4Char8utf8SizeER_ZN11std$FS$core5ArrayIhEl"(i8 addrspace(1)*, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)*, i64) local_unnamed_addr gc "cangjie"
declare void @"_ZN11std$FS$core6String12$utf8ViewgetEv"(%"record._ZN11std$FS$core8Utf8ViewE"* noalias sret(%"record._ZN11std$FS$core8Utf8ViewE"), i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*) local_unnamed_addr gc "cangjie"
declare void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias sret(%"record._ZN11std$FS$core6StringE"), i8*, i64) local_unnamed_addr gc "cangjie"
declare void @"_ZN11std$FS$core6String4joinER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core6StringEER_ZN11std$FS$core6StringE"(%"record._ZN11std$FS$core6StringE"* noalias sret(%"record._ZN11std$FS$core6StringE"), i8 addrspace(1)*, %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE" addrspace(1)*, i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*) local_unnamed_addr gc "cangjie"
declare void @"_ZN17std$FS$collection11std$FS$core5ArrayIh6copyToER_ZN11std$FS$core5ArrayIhElll"(%Unit.Type* noalias nocapture readnone sret(%Unit.Type) %0, i8 addrspace(1)* nocapture readnone %"__auto_v_1036$BP", %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* nocapture readonly %this, i8 addrspace(1)* nocapture readnone %"dst$BP", %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* nocapture readonly %dst, i64 %srcStart, i64 %dstStart, i64 %copyLen) unnamed_addr gc "cangjie"
declare void @"_ZN17std$FS$collection13StringBuilder16checkRangeInsertEl"(%Unit.Type* noalias nocapture readnone sret(%Unit.Type) %0, i8 addrspace(1)* nocapture readonly %this, i64 %index) local_unnamed_addr gc "cangjie"
declare void @"_ZN17std$FS$collection13StringBuilder7reserveEl"(i8 addrspace(1)* %this, i64 %additional) unnamed_addr gc "cangjie"
declare void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)*, i8 addrspace(1)* noalias nocapture writeonly, i8* noalias nocapture readonly, i64)
declare void @llvm.cj.gcwrite.i32.i32(i32, i8 addrspace(1)* nocapture, i32 addrspace(1)* nocapture)
declare void @llvm.cj.gcwrite.i64.i64(i64, i8 addrspace(1)* nocapture, i64 addrspace(1)* nocapture)
declare void @llvm.cj.memset.p0i8(i8*, i8, i64, i1)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64)
declare i64 @llvm.smax.i64(i64, i64)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64)
declare i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)*, %"record._ZN11std$FS$core6StringE" addrspace(1)*) local_unnamed_addr gc "cangjie"

define i8 addrspace(1)* @hoo1(i8 addrspace(1)* returned %this, i64 %index, i8 addrspace(1)* %"str$BP", %"record._ZN11std$FS$core6StringE" addrspace(1)* %str) gc "cangjie" {
entry:
  %callRet.i = alloca %Unit.Type
  %callRet6 = alloca %Unit.Type
  %enumTmp.sroa.0 = alloca %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE"
  %strData = alloca %"record._ZN11std$FS$core8Utf8ViewE"
  %callRet1 = alloca %"record._ZN11std$FS$core8Utf8ViewE"
  %enumTmp.sroa.0.0.sroa_cast8 = bitcast %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE"* %enumTmp.sroa.0 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp.sroa.0.0.sroa_cast8, i8 0, i64 24, i1 false)
  %0 = bitcast %"record._ZN11std$FS$core8Utf8ViewE"* %strData to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %0, i8 0, i64 24, i1 false)
  %1 = bitcast %"record._ZN11std$FS$core8Utf8ViewE"* %callRet1 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %1, i8 0, i64 24, i1 false)
  call void @"_ZN17std$FS$collection13StringBuilder16checkRangeInsertEl"(%Unit.Type* noalias sret(%Unit.Type) poison, i8 addrspace(1)* %this, i64 %index)
  call void @"_ZN11std$FS$core6String12$utf8ViewgetEv"(%"record._ZN11std$FS$core8Utf8ViewE"* noalias nonnull sret(%"record._ZN11std$FS$core8Utf8ViewE") %callRet1, i8 addrspace(1)* %"str$BP", %"record._ZN11std$FS$core6StringE" addrspace(1)* %str)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %0, i8* noundef nonnull align 8 dereferenceable(24) %1, i64 24, i1 false)
  %2 = getelementptr inbounds %"record._ZN11std$FS$core8Utf8ViewE", %"record._ZN11std$FS$core8Utf8ViewE"* %strData, i64 0, i32 0, i32 2
  %3 = load i64, i64* %2
  call fastcc void @"_ZN17std$FS$collection13StringBuilder7reserveEl"(i8 addrspace(1)* %this, i64 %3)
  %icmpeq = icmp eq i64 %index, 0
  br i1 %icmpeq, label %if.end16502E, label %if.else16502E

if.else16502E:                                    ; preds = %entry
  %4 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 32
  %5 = bitcast i8 addrspace(1)* %4 to i64 addrspace(1)*
  %6 = load i64, i64 addrspace(1)* %5
  %icmpeq3 = icmp eq i64 %6, %index
  br i1 %icmpeq3, label %if.then16501E, label %if.else16501E

if.then16501E:                                    ; preds = %if.else16502E
  %7 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 40
  %8 = bitcast i8 addrspace(1)* %7 to i64 addrspace(1)*
  %9 = load i64, i64 addrspace(1)* %8
  br label %if.end16502E

if.else16501E:                                    ; preds = %if.else16502E
  %smax.i = call i64 @llvm.smax.i64(i64 %index, i64 0)
  %exitcond7.not.i = icmp slt i64 %index, 1
  br i1 %exitcond7.not.i, label %if.end16502E, label %while.body325E.lr.ph.i

while.body325E.lr.ph.i:                           ; preds = %if.else16501E
  %10 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %11 = bitcast i8 addrspace(1)* %10 to %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)*
  br label %while.body325E.i

while.body325E.i:                                 ; preds = %while.body325E.i, %while.body325E.lr.ph.i
  %atom.17274E.010.i = phi i64 [ 0, %while.body325E.lr.ph.i ], [ %add.i, %while.body325E.i ]
  %atom.17272E.09.i = phi i64 [ 0, %while.body325E.lr.ph.i ], [ %add1.i, %while.body325E.i ]
  %atom.17268E.08.i = phi i64 [ 0, %while.body325E.lr.ph.i ], [ %spec.select.i, %while.body325E.i ]
  %12 = call i64 @"_ZN11std$FS$core6Extend4Char8utf8SizeER_ZN11std$FS$core5ArrayIhEl"(i8 addrspace(1)* %this, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* %11, i64 %atom.17272E.09.i), !noalias !2
  %add.i = add nuw nsw i64 %atom.17274E.010.i, 1
  %add1.i = add i64 %12, %atom.17272E.09.i
  %icmpeq2.i = icmp eq i64 %add.i, %index
  %spec.select.i = select i1 %icmpeq2.i, i64 %add1.i, i64 %atom.17268E.08.i
  %exitcond.not.i = icmp eq i64 %add.i, %smax.i
  br i1 %exitcond.not.i, label %if.end16502E, label %while.body325E.i

if.end16502E:                                     ; preds = %while.body325E.i, %if.else16501E, %entry, %if.then16501E
  %atom.17381E.0 = phi i64 [ %9, %if.then16501E ], [ 0, %entry ], [ 0, %if.else16501E ], [ %spec.select.i, %while.body325E.i ]
  %13 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 40
  %14 = bitcast i8 addrspace(1)* %13 to i64 addrspace(1)*
  %15 = load i64, i64 addrspace(1)* %14
  %icmpne.not = icmp eq i64 %15, %atom.17381E.0
  br i1 %icmpne.not, label %if.end16525E, label %if.then16525E

if.then16525E:                                    ; preds = %if.end16502E
  %16 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %17 = bitcast i8 addrspace(1)* %16 to %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)*
  %add = add i64 %atom.17381E.0, %3
  %sub = sub i64 %15, %atom.17381E.0
  call fastcc void @"_ZN17std$FS$collection11std$FS$core5ArrayIh6copyToER_ZN11std$FS$core5ArrayIhElll"(%Unit.Type* noalias nonnull sret(%Unit.Type) %callRet6, i8 addrspace(1)* %this, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* %17, i8 addrspace(1)* %this, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* %17, i64 %atom.17381E.0, i64 %add, i64 %sub)
  br label %if.end16525E

if.end16525E:                                     ; preds = %if.end16502E, %if.then16525E
  %18 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %19 = bitcast i8 addrspace(1)* %18 to %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)*
  %20 = addrspacecast %"record._ZN11std$FS$core8Utf8ViewE"* %strData to %"record._ZN11std$FS$core8Utf8ViewE" addrspace(1)*
  %21 = getelementptr inbounds %Unit.Type, %Unit.Type* %callRet.i, i64 0, i32 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %21)
  %22 = getelementptr inbounds %"record._ZN11std$FS$core8Utf8ViewE", %"record._ZN11std$FS$core8Utf8ViewE" addrspace(1)* %20, i64 0, i32 0
  %23 = getelementptr inbounds %"record._ZN11std$FS$core8Utf8ViewE", %"record._ZN11std$FS$core8Utf8ViewE" addrspace(1)* %20, i64 0, i32 0, i32 2
  %24 = addrspacecast i64 addrspace(1)* %23 to i64*
  %25 = load i64, i64* %24
  call fastcc void @"_ZN17std$FS$collection11std$FS$core5ArrayIh6copyToER_ZN11std$FS$core5ArrayIhElll"(%Unit.Type* noalias nonnull sret(%Unit.Type) %callRet.i, i8 addrspace(1)* null, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* %22, i8 addrspace(1)* %this, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* %19, i64 0, i64 %atom.17381E.0, i64 %25)
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %21)
  %26 = load i64, i64 addrspace(1)* %14
  %add7 = add i64 %26, %3
  call void @llvm.cj.gcwrite.i64.i64(i64 %add7, i8 addrspace(1)* %this, i64 addrspace(1)* %14)
  %27 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 32
  %28 = bitcast i8 addrspace(1)* %27 to i64 addrspace(1)*
  %29 = load i64, i64 addrspace(1)* %28
  %30 = getelementptr inbounds %"record._ZN11std$FS$core6StringE", %"record._ZN11std$FS$core6StringE" addrspace(1)* %str, i64 0, i32 1
  %31 = load i64, i64 addrspace(1)* %30
  %add8 = add i64 %31, %29
  call void @llvm.cj.gcwrite.i64.i64(i64 %add8, i8 addrspace(1)* %this, i64 addrspace(1)* %28)
  ret i8 addrspace(1)* %this
}

define weak_odr void @hoo2(%"record._ZN17std$FS$collection11std$FS$core5ArrayIcE"* noalias sret(%"record._ZN17std$FS$collection11std$FS$core5ArrayIcE") %0, i8 addrspace(1)* %this) gc "cangjie" {
entry:
  %enumTmp7 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet6 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp = alloca %"record._ZN11std$FS$core6StringE"
  %callRet1 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet = alloca %T2_clE
  %enumTmp7.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp7 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp7.0.sroa_cast, i8 0, i64 16, i1 false)
  %1 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet6 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %enumTmp.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp.0.sroa_cast, i8 0, i64 16, i1 false)
  %2 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet1 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %2, i8 0, i64 16, i1 false)
  %3 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 32
  %4 = bitcast i8 addrspace(1)* %3 to i64 addrspace(1)*
  %5 = load i64, i64 addrspace(1)* %4
  %arr.alloc.size.valid = icmp sgt i64 %5, -1
  br i1 %arr.alloc.size.valid, label %arr.alloc.body0E, label %arr.alloc.throw0E

arr.alloc.throw0E:                                ; preds = %entry
  %6 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core26NegativeArraySizeExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core26NegativeArraySizeException4initEv"(i8 addrspace(1)* %6)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %6)
  unreachable

arr.alloc.body0E:                                 ; preds = %entry
  %7 = call noalias i8 addrspace(1)* @CJ_MCC_NewArray32Stub(i64 %5, i8* bitcast (%KlassInfo.0* @Char.arrayKlass to i8*))
  %size.is-zero = icmp eq i64 %5, 0
  br i1 %size.is-zero, label %arr.init.opt0E, label %arr.init.body0E.preheader

arr.init.body0E.preheader:                        ; preds = %arr.alloc.body0E
  %8 = getelementptr inbounds i8, i8 addrspace(1)* %7, i64 16
  %9 = bitcast i8 addrspace(1)* %8 to i32 addrspace(1)*
  br label %arr.init.body0E

arr.init.body0E:                                  ; preds = %arr.init.body0E.preheader, %arr.init.body0E
  %iterator.0 = phi i64 [ %11, %arr.init.body0E ], [ 0, %arr.init.body0E.preheader ]
  %10 = getelementptr inbounds i32, i32 addrspace(1)* %9, i64 %iterator.0
  call void @llvm.cj.gcwrite.i32.i32(i32 32, i8 addrspace(1)* %7, i32 addrspace(1)* %10)
  %11 = add nuw nsw i64 %iterator.0, 1
  %exitcond.not = icmp eq i64 %11, %5
  br i1 %exitcond.not, label %arr.init.opt0E, label %arr.init.body0E

arr.init.opt0E:                                   ; preds = %arr.init.body0E, %arr.alloc.body0E
  %12 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 40
  %13 = bitcast i8 addrspace(1)* %12 to i64 addrspace(1)*
  %14 = load i64, i64 addrspace(1)* %13
  %icmpslt23 = icmp sgt i64 %14, 0
  br i1 %icmpslt23, label %while.body9072E.lr.ph, label %block.end9027E

while.body9072E.lr.ph:                            ; preds = %arr.init.opt0E
  %15 = getelementptr inbounds i8, i8 addrspace(1)* %this, i64 8
  %16 = bitcast i8 addrspace(1)* %15 to %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)*
  %17 = getelementptr inbounds %T2_clE, %T2_clE* %callRet, i64 0, i32 1
  %18 = getelementptr inbounds %T2_clE, %T2_clE* %callRet, i64 0, i32 0
  %19 = bitcast i8 addrspace(1)* %7 to %ArrayLayout.Char addrspace(1)*
  br label %while.body9072E

while.body9072E:                                  ; preds = %while.body9072E.lr.ph, %normal0E5
  %atom.17365E.025 = phi i64 [ 0, %while.body9072E.lr.ph ], [ %.fca.0.extract18, %normal0E5 ]
  %atom.17367E.024 = phi i64 [ 0, %while.body9072E.lr.ph ], [ %.fca.0.extract, %normal0E5 ]
  call void @"_ZN11std$FS$core6Extend4Char8fromUtf8ER_ZN11std$FS$core5ArrayIhEl"(%T2_clE* noalias nonnull sret(%T2_clE) %callRet, i8 addrspace(1)* %this, %"record._ZN17std$FS$collection11std$FS$core5ArrayIhE" addrspace(1)* %16, i64 %atom.17367E.024)
  %icmpuge.not = icmp ult i64 %atom.17365E.025, %5
  br i1 %icmpuge.not, label %if.else19175E, label %if.then19175E

if.then19175E:                                    ; preds = %while.body9072E
  %20 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %20)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %20)
  unreachable

if.else19175E:                                    ; preds = %while.body9072E
  %21 = load i64, i64* %17
  %22 = load i32, i32* %18
  %arr.idx.set.gep = getelementptr inbounds %ArrayLayout.Char, %ArrayLayout.Char addrspace(1)* %19, i64 0, i32 1, i64 %atom.17365E.025
  call void @llvm.cj.gcwrite.i32.i32(i32 %22, i8 addrspace(1)* %7, i32 addrspace(1)* %arr.idx.set.gep)
  %23 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %atom.17367E.024, i64 %21)
  %.fca.0.extract = extractvalue { i64, i1 } %23, 0
  %.fca.1.extract = extractvalue { i64, i1 } %23, 1
  br i1 %.fca.1.extract, label %overflow0E, label %normal0E, !prof !1

normal0E:                                         ; preds = %if.else19175E
  %24 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %atom.17365E.025, i64 1)
  %.fca.1.extract19 = extractvalue { i64, i1 } %24, 1
  br i1 %.fca.1.extract19, label %overflow0E4, label %normal0E5, !prof !1

overflow0E:                                       ; preds = %if.else19175E
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet1, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.29", i64 0, i64 0), i64 3)
  %25 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet1 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %26 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %25)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %26)
  unreachable

normal0E5:                                        ; preds = %normal0E
  %.fca.0.extract18 = extractvalue { i64, i1 } %24, 0
  %27 = load i64, i64 addrspace(1)* %13
  %icmpslt = icmp slt i64 %.fca.0.extract, %27
  br i1 %icmpslt, label %while.body9072E, label %block.end9027E

overflow0E4:                                      ; preds = %normal0E
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.29", i64 0, i64 0), i64 3)
  %28 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet6 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %29 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %28)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %29)
  unreachable

block.end9027E:                                   ; preds = %normal0E5, %arr.init.opt0E
  %charArray.sroa.0.0..sroa_idx = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core5ArrayIcE", %"record._ZN17std$FS$collection11std$FS$core5ArrayIcE"* %0, i64 0, i32 0
  store i8 addrspace(1)* %7, i8 addrspace(1)** %charArray.sroa.0.0..sroa_idx
  %charArray.sroa.4.0..sroa_idx10 = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core5ArrayIcE", %"record._ZN17std$FS$collection11std$FS$core5ArrayIcE"* %0, i64 0, i32 1
  store i64 0, i64* %charArray.sroa.4.0..sroa_idx10
  %charArray.sroa.5.0..sroa_idx11 = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core5ArrayIcE", %"record._ZN17std$FS$collection11std$FS$core5ArrayIcE"* %0, i64 0, i32 2
  store i64 %5, i64* %charArray.sroa.5.0..sroa_idx11
  ret void
}

define void @hoo3(%"record._ZN11std$FS$core6StringE"* noalias nocapture writeonly sret(%"record._ZN11std$FS$core6StringE") %0, i8 addrspace(1)* %it) unnamed_addr gc "cangjie" {
entry:
  %enumTmp38 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp37 = alloca %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"
  %callRet36 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp32 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet31 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp26 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet25 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp17 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet16 = alloca %"record._ZN11std$FS$core6StringE"
  %value = alloca %"record._ZN11std$FS$core6StringE"
  %callRet9 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet7 = alloca %"record._ZN17std$FS$collection11std$FS$core6OptionIcE"
  %stringArray = alloca %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"
  %enumTmp6 = alloca %"record._ZN11std$FS$core6StringE"
  %callRet5 = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp = alloca %"record._ZN11std$FS$core6StringE"
  %callRet = alloca %"record._ZN11std$FS$core6StringE"
  %block16070val = alloca %"record._ZN11std$FS$core6StringE"
  %enumTmp38.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp38 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp38.0.sroa_cast, i8 0, i64 16, i1 false)
  %enumTmp37.0.sroa_cast = bitcast %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"* %enumTmp37 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp37.0.sroa_cast, i8 0, i64 24, i1 false)
  %1 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet36 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %1, i8 0, i64 16, i1 false)
  %enumTmp32.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp32 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp32.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet31.0.sroa_cast46 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet31 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet31.0.sroa_cast46, i8 0, i64 16, i1 false)
  %enumTmp26.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp26 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp26.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet25.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %callRet25 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet25.0.sroa_cast, i8 0, i64 16, i1 false)
  %enumTmp17.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp17 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp17.0.sroa_cast, i8 0, i64 16, i1 false)
  %2 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet16 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %2, i8 0, i64 16, i1 false)
  %3 = bitcast %"record._ZN11std$FS$core6StringE"* %value to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %3, i8 0, i64 16, i1 false)
  %4 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet9 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %4, i8 0, i64 16, i1 false)
  %5 = bitcast %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"* %stringArray to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %5, i8 0, i64 24, i1 false)
  %enumTmp6.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp6 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp6.0.sroa_cast, i8 0, i64 16, i1 false)
  %callRet5.0.sroa_cast45 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet5 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %callRet5.0.sroa_cast45, i8 0, i64 16, i1 false)
  %enumTmp.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %enumTmp to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %enumTmp.0.sroa_cast, i8 0, i64 16, i1 false)
  %6 = bitcast %"record._ZN11std$FS$core6StringE"* %callRet to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %6, i8 0, i64 16, i1 false)
  %block16070val.0.sroa_cast = bitcast %"record._ZN11std$FS$core6StringE"* %block16070val to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %block16070val.0.sroa_cast, i8 0, i64 16, i1 false)
  %7 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %it)
  %8 = getelementptr i8, i8* %7, i64 32
  %9 = bitcast i8* %8 to i64**
  %10 = load i64*, i64** %9
  %11 = call i8* @CJ_MCC_GetFuncPtrFromItab(i64* %10, i32 17, i32 2821, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @"$const_string.35", i64 0, i64 0))
  %12 = bitcast i8* %11 to i64 (i8 addrspace(1)*)*
  %13 = call i64 %12(i8 addrspace(1)* %it)
  %icmpeq = icmp eq i64 %13, 0
  br i1 %icmpeq, label %common.ret, label %if.else16086E

common.ret:                                       ; preds = %entry, %if.else28490E
  %.sink47 = phi i8* [ %1, %if.else28490E ], [ bitcast (%"record._ZN11std$FS$core6StringE"* @"_ZN15std$$collection22$__STRING_LITERAL__$22E" to i8*), %entry ]
  %14 = bitcast %"record._ZN11std$FS$core6StringE"* %0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %14, i8* noundef nonnull align 8 dereferenceable(16) %.sink47, i64 16, i1 false)
  ret void

if.else16086E:                                    ; preds = %entry
  %15 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %13, i64 2)
  %.fca.1.extract = extractvalue { i64, i1 } %15, 1
  br i1 %.fca.1.extract, label %overflow0E, label %normal0E, !prof !1

normal0E:                                         ; preds = %if.else16086E
  %.fca.0.extract = extractvalue { i64, i1 } %15, 0
  %16 = or i64 %.fca.0.extract, 1
  %arr.alloc.size.valid = icmp sgt i64 %16, -1
  br i1 %arr.alloc.size.valid, label %arr.alloc.body0E, label %arr.alloc.throw0E

overflow0E:                                       ; preds = %if.else16086E
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.30", i64 0, i64 0), i64 3)
  %17 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %18 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %17)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %18)
  unreachable

arr.alloc.throw0E:                                ; preds = %normal0E
  %19 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core26NegativeArraySizeExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core26NegativeArraySizeException4initEv"(i8 addrspace(1)* %19)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %19)
  unreachable

arr.alloc.body0E:                                 ; preds = %normal0E
  %20 = call noalias i8 addrspace(1)* @CJ_MCC_NewArrayStub(i64 %16, i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core6StringE.arrayKlass" to i8*))
  %21 = getelementptr inbounds i8, i8 addrspace(1)* %20, i64 16
  %22 = bitcast i8 addrspace(1)* %21 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  br label %arr.init.body0E

arr.init.body0E:                                  ; preds = %arr.init.body0E, %arr.alloc.body0E
  %iterator.0 = phi i64 [ 0, %arr.alloc.body0E ], [ %25, %arr.init.body0E ]
  %23 = getelementptr inbounds %"record._ZN11std$FS$core6StringE", %"record._ZN11std$FS$core6StringE" addrspace(1)* %22, i64 %iterator.0
  %24 = bitcast %"record._ZN11std$FS$core6StringE" addrspace(1)* %23 to i8 addrspace(1)*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %20, i8 addrspace(1)* %24, i8* bitcast (%"record._ZN11std$FS$core6StringE"* @"_ZN11std$FS$core6String5emptyE" to i8*), i64 16)
  %25 = add nuw nsw i64 %iterator.0, 1
  %exitcond.not = icmp eq i64 %25, %16
  br i1 %exitcond.not, label %arr.init.opt0E, label %arr.init.body0E

arr.init.opt0E:                                   ; preds = %arr.init.body0E
  %atom.17657E.sroa.0.0..sroa_idx11 = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE", %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"* %stringArray, i64 0, i32 0
  store i8 addrspace(1)* %20, i8 addrspace(1)** %atom.17657E.sroa.0.0..sroa_idx11
  %atom.17657E.sroa.4.0..sroa_idx14 = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE", %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"* %stringArray, i64 0, i32 1
  store i64 0, i64* %atom.17657E.sroa.4.0..sroa_idx14
  %atom.17657E.sroa.5.0..sroa_idx17 = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE", %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"* %stringArray, i64 0, i32 2
  store i64 %16, i64* %atom.17657E.sroa.5.0..sroa_idx17
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %20, i8 addrspace(1)* %21, i8* bitcast (%"record._ZN11std$FS$core6StringE"* @"_ZN15std$$collection22$__STRING_LITERAL__$23E" to i8*), i64 16)
  %26 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %it)
  %27 = getelementptr i8, i8* %26, i64 32
  %28 = bitcast i8* %27 to i64**
  %29 = load i64*, i64** %28
  %30 = call i8* @CJ_MCC_GetFuncPtrFromItab(i64* %29, i32 18, i32 110, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @"$const_string.33", i64 0, i64 0))
  %31 = bitcast i8* %30 to i8 addrspace(1)* (i8 addrspace(1)*)*
  %32 = call i8 addrspace(1)* %31(i8 addrspace(1)* %it)
  %33 = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core6OptionIcE", %"record._ZN17std$FS$collection11std$FS$core6OptionIcE"* %callRet7, i64 0, i32 0
  %34 = getelementptr inbounds %"record._ZN17std$FS$collection11std$FS$core6OptionIcE", %"record._ZN17std$FS$collection11std$FS$core6OptionIcE"* %callRet7, i64 0, i32 1
  br label %block.body16122E

block.body16122E:                                 ; preds = %if.else28455E, %arr.init.opt0E
  %atom.17659E.0 = phi i64 [ 1, %arr.init.opt0E ], [ %.fca.0.extract29, %if.else28455E ]
  %35 = call i8* @CJ_MCC_GetObjClass(i8 addrspace(1)* %32)
  %36 = getelementptr i8, i8* %35, i64 32
  %37 = bitcast i8* %36 to i64**
  %38 = load i64*, i64** %37
  %39 = call i8* @CJ_MCC_GetFuncPtrFromItab(i64* %38, i32 10, i32 907, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @"$const_string.34", i64 0, i64 0))
  %40 = bitcast i8* %39 to void (%"record._ZN17std$FS$collection11std$FS$core6OptionIcE"*, i8 addrspace(1)*)*
  call void %40(%"record._ZN17std$FS$collection11std$FS$core6OptionIcE"* noalias nonnull sret(%"record._ZN17std$FS$collection11std$FS$core6OptionIcE") %callRet7, i8 addrspace(1)* %32)
  %41 = load i1, i1* %33
  br i1 %41, label %normal0E30, label %if.else16170E

if.else16170E:                                    ; preds = %block.body16122E
  %42 = load i32, i32* %34, align 4
  call void @"_ZN11std$FS$core6Extend4Char8toStringEv"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet9, i32 %42)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %3, i8* noundef nonnull align 8 dereferenceable(16) %4, i64 16, i1 false)
  %icmpuge10.not = icmp ult i64 %atom.17659E.0, %16
  br i1 %icmpuge10.not, label %if.else28420E, label %if.then28420E

if.then28420E:                                    ; preds = %if.else16170E
  %43 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %43)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %43)
  unreachable

if.else28420E:                                    ; preds = %if.else16170E
  %44 = load i8 addrspace(1)*, i8 addrspace(1)** %atom.17657E.sroa.0.0..sroa_idx11
  %45 = bitcast i8 addrspace(1)* %44 to %"ArrayLayout._ZN11std$FS$core6StringE" addrspace(1)*
  %arr.idx.set.gep11 = getelementptr inbounds %"ArrayLayout._ZN11std$FS$core6StringE", %"ArrayLayout._ZN11std$FS$core6StringE" addrspace(1)* %45, i64 0, i32 1, i64 %atom.17659E.0
  %46 = bitcast %"record._ZN11std$FS$core6StringE" addrspace(1)* %arr.idx.set.gep11 to i8 addrspace(1)*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %44, i8 addrspace(1)* %46, i8* nonnull %3, i64 16)
  %47 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %atom.17659E.0, i64 1)
  %.fca.0.extract24 = extractvalue { i64, i1 } %47, 0
  %.fca.1.extract25 = extractvalue { i64, i1 } %47, 1
  br i1 %.fca.1.extract25, label %overflow0E14, label %normal0E15, !prof !1

normal0E15:                                       ; preds = %if.else28420E
  %icmpuge19.not = icmp ult i64 %.fca.0.extract24, %16
  br i1 %icmpuge19.not, label %if.else28455E, label %if.then28455E

overflow0E14:                                     ; preds = %if.else28420E
  call void @"_ZN11std$FS$core6String23createStringFromLiteralE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet16, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"$const_string.29", i64 0, i64 0), i64 3)
  %48 = addrspacecast %"record._ZN11std$FS$core6StringE"* %callRet16 to %"record._ZN11std$FS$core6StringE" addrspace(1)*
  %49 = call i8 addrspace(1)* @"rt$CreateOverflowException_msg"(i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* %48)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %49)
  unreachable

if.then28455E:                                    ; preds = %normal0E15
  %50 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %50)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %50)
  unreachable

if.else28455E:                                    ; preds = %normal0E15
  %51 = load i8 addrspace(1)*, i8 addrspace(1)** %atom.17657E.sroa.0.0..sroa_idx11
  %52 = bitcast i8 addrspace(1)* %51 to %"ArrayLayout._ZN11std$FS$core6StringE" addrspace(1)*
  %arr.idx.set.gep20 = getelementptr inbounds %"ArrayLayout._ZN11std$FS$core6StringE", %"ArrayLayout._ZN11std$FS$core6StringE" addrspace(1)* %52, i64 0, i32 1, i64 %.fca.0.extract24
  %53 = bitcast %"record._ZN11std$FS$core6StringE" addrspace(1)* %arr.idx.set.gep20 to i8 addrspace(1)*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %51, i8 addrspace(1)* %53, i8* bitcast (%"record._ZN11std$FS$core6StringE"* @"_ZN15std$$collection22$__STRING_LITERAL__$24E" to i8*), i64 16)
  %.fca.0.extract29 = add nuw i64 %atom.17659E.0, 2
  br label %block.body16122E

normal0E30:                                       ; preds = %block.body16122E
  %icmpuge34.not = icmp ult i64 %.fca.0.extract, %16
  br i1 %icmpuge34.not, label %if.else28490E, label %if.then28490E

if.then28490E:                                    ; preds = %normal0E30
  %54 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %54)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %54)
  unreachable

if.else28490E:                                    ; preds = %normal0E30
  %55 = load i8 addrspace(1)*, i8 addrspace(1)** %atom.17657E.sroa.0.0..sroa_idx11
  %56 = bitcast i8 addrspace(1)* %55 to %"ArrayLayout._ZN11std$FS$core6StringE" addrspace(1)*
  %arr.idx.set.gep35 = getelementptr inbounds %"ArrayLayout._ZN11std$FS$core6StringE", %"ArrayLayout._ZN11std$FS$core6StringE" addrspace(1)* %56, i64 0, i32 1, i64 %.fca.0.extract
  %57 = bitcast %"record._ZN11std$FS$core6StringE" addrspace(1)* %arr.idx.set.gep35 to i8 addrspace(1)*
  call void @llvm.cj.gcwrite.struct.p0i8(i8 addrspace(1)* %55, i8 addrspace(1)* %57, i8* bitcast (%"record._ZN11std$FS$core6StringE"* @"_ZN15std$$collection22$__STRING_LITERAL__$25E" to i8*), i64 16)
  %58 = addrspacecast %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE"* %stringArray to %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE" addrspace(1)*
  call void @"_ZN11std$FS$core6String4joinER_ZN11std$FS$core5ArrayIR_ZN11std$FS$core6StringEER_ZN11std$FS$core6StringE"(%"record._ZN11std$FS$core6StringE"* noalias nonnull sret(%"record._ZN11std$FS$core6StringE") %callRet36, i8 addrspace(1)* null, %"record._ZN17std$FS$collection11std$FS$core5ArrayIR_ZN11std$FS$core6StringEE" addrspace(1)* %58, i8 addrspace(1)* null, %"record._ZN11std$FS$core6StringE" addrspace(1)* addrspacecast (%"record._ZN11std$FS$core6StringE"* @"_ZN11std$FS$core6String5emptyE" to %"record._ZN11std$FS$core6StringE" addrspace(1)*))
  br label %common.ret
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"CJBC", i32 1}
!1 = !{!"branch_weights", i32 1, i32 2000}
!2 = !{!3}
!3 = distinct !{!3, !4, !"_ZN17std$FS$collection13StringBuilder25fromCharIndexToUInt8IndexEll: argument 0"}
!4 = distinct !{!4, !"_ZN17std$FS$collection13StringBuilder25fromCharIndexToUInt8IndexEll"}
