; RUN: opt --cangjie-pipeline -partial-inliner -skip-partial-inlining-cost-analysis -S < %s | FileCheck %s

; CHECK: %pi_gep
; CHECK: %pi_bitcastgep

%KlassInfo.0 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [0 x i8*] }
%BitMap = type { i32, [0 x i8] }
%KlassInfo.1 = type { i32, i32, %BitMap*, i8*, i8**, i64*, i64*, i64*, i32, [1 x i8*] }
%Unit.Type = type { i8 }
%_ZN07ClosureE = type { i8*, i8 addrspace(1)* }
%ObjLayout.Object = type { %KlassInfo.0* }
%ArrayBase = type { %ObjLayout.Object, i64 }
%"T2_R_ZN11std$FS$core5ArrayIjElE" = type { %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE", i64 }
%"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" = type { i8 addrspace(1)*, i64, i64 }
%"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE" = type { i8 addrspace(1)*, i64, i64 }
%"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" = type { %ArrayBase, [0 x %"T2_R_ZN11std$FS$core5ArrayIjElE"] }
%ArrayLayout.UInt32 = type { %ArrayBase, [0 x i32] }
%"ObjLayout._ZN11std$FS$core6ObjectE" = type { %ObjLayout.Object }
%"ObjLayout._ZN17numeric$FS$bigint21__Auto__Environment_5E" = type { %"ObjLayout._ZN11std$FS$core6ObjectE", %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 }

@"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE" = private global [3 x i64] zeroinitializer, section "__llvm_prf_cnts", align 8
@"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE" = private global [12 x i64] zeroinitializer, section "__llvm_prf_cnts", align 8
@"__profd_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE" = private global { i64, i64, i64, i8*, i8*, i32, [2 x i16] } { i64 1145983669766020984, i64 543243706801081985, i64 sub (i64 ptrtoint ([3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE" to i64), i64 ptrtoint ({ i64, i64, i64, i8*, i8*, i32, [2 x i16] }* @"__profd_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE" to i64)), i8* null, i8* bitcast ([1 x i64]* @"__profvp_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE" to i8*), i32 3, [2 x i16] [i16 1, i16 0] }, section "__llvm_prf_data", align 8
@"__profvp_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE" = private global [1 x i64] zeroinitializer, section "__llvm_prf_vals", align 8
@A1_jE.className = weak_odr hidden global [6 x i8] c"A1_jE\00", align 1
@"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" = external global %KlassInfo.0
@"_ZN11std$FS$core26NegativeArraySizeExceptionE.objKlass" = external global %KlassInfo.0
@UInt32.arrayKlass = weak_odr hidden global %KlassInfo.0 { i32 0, i32 0, %BitMap* null, i8* null, i8** null, i64* null, i64* null, i64* bitcast ([6 x i8]* @A1_jE.className to i64*), i32 0, [0 x i8*] zeroinitializer }
@"_ZN11std$FS$core6ObjectE.objKlass" = external global %KlassInfo.1
@"_ZN17numeric$FS$bigint21__Auto__Environment_5E.objKlass" = internal global %KlassInfo.0 { i32 0, i32 0, %BitMap* null, i8* bitcast (%KlassInfo.1* @"_ZN11std$FS$core6ObjectE.objKlass" to i8*), i8** null, i64* null, i64* null, i64* null, i32 0, [0 x i8*] zeroinitializer }

define internal fastcc void @"_ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE"(%"T2_R_ZN11std$FS$core5ArrayIjElE"* noalias nocapture writeonly sret(%"T2_R_ZN11std$FS$core5ArrayIjElE") %0, i8 addrspace(1)* nocapture readnone %"arr$BP", %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE" addrspace(1)* nocapture readonly %arr) unnamed_addr #13 gc "cangjie" personality i32 (...)* @"__cj_personality_v0$" {
entry:
  %callRet88 = alloca %"T2_R_ZN11std$FS$core5ArrayIjElE", align 8
  %arr.get86.sroa.0 = alloca %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE", align 8
  %arr.get76.sroa.0 = alloca { i8 addrspace(1)*, i64 }, align 8
  %arr.get67 = alloca %"T2_R_ZN11std$FS$core5ArrayIjElE", align 8
  %callRet52 = alloca %Unit.Type, align 8
  %arr.get50 = alloca %"T2_R_ZN11std$FS$core5ArrayIjElE", align 8
  %rest = alloca %"T2_R_ZN11std$FS$core5ArrayIjElE", align 8
  %arr.get30.sroa.0 = alloca { i8 addrspace(1)*, i64 }, align 8
  %closure = alloca %_ZN07ClosureE, align 8
  %arr.get10.sroa.0 = alloca { i8 addrspace(1)*, i64 }, align 8
  %arr.get.sroa.0 = alloca %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE", align 8
  %1 = getelementptr inbounds %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE" addrspace(1)* %arr, i64 0, i32 2
  %2 = load i64, i64 addrspace(1)* %1, align 8
  %icmpuge = icmp eq i64 %2, 0
  br i1 %icmpuge, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %pgocount = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 3), align 8
  %3 = add i64 %pgocount, 1
  store i64 %3, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 3), align 8
  %4 = tail call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  tail call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %4)
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %4)
  unreachable

if.else:                                          ; preds = %entry
  %5 = bitcast %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE" addrspace(1)* %arr to %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* addrspace(1)*
  %6 = load %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* addrspace(1)* %5, align 8
  %7 = getelementptr inbounds %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE" addrspace(1)* %arr, i64 0, i32 1
  %8 = load i64, i64 addrspace(1)* %7, align 8
  %arr.idx.get.gep = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %6, i64 0, i32 1, i64 %8
  %arr.get.sroa.0.0.sroa_cast6 = bitcast %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE"* %arr.get.sroa.0 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %arr.get.sroa.0.0.sroa_cast6, i8 0, i64 24, i1 false)
  %arr.get.sroa.0.0..sroa_cast = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %arr.idx.get.gep to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %arr.get.sroa.0.0.sroa_cast6, i8 addrspace(1)* noundef align 8 dereferenceable(24) %arr.get.sroa.0.0..sroa_cast, i64 24, i1 false)
  %arr.get.sroa.2.0..sroa_idx5 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %6, i64 0, i32 1, i64 %8, i32 1
  %arr.get.sroa.2.0.copyload = load i64, i64 addrspace(1)* %arr.get.sroa.2.0..sroa_idx5, align 8
  %9 = load i64, i64 addrspace(1)* %1, align 8
  %icmpuge4 = icmp eq i64 %9, 0
  br i1 %icmpuge4, label %if.then7, label %if.else6

if.then7:                                         ; preds = %if.else
  %pgocount84 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 4), align 8
  %10 = add i64 %pgocount84, 1
  store i64 %10, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 4), align 8
  %11 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %11)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %11)
  unreachable

if.else6:                                         ; preds = %if.else
  %12 = load %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* addrspace(1)* %5, align 8
  %13 = load i64, i64 addrspace(1)* %7, align 8
  %arr.idx.get.gep9 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %12, i64 0, i32 1, i64 %13
  %arr.get10.sroa.0.0.sroa_cast13 = bitcast { i8 addrspace(1)*, i64 }* %arr.get10.sroa.0 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %arr.get10.sroa.0.0.sroa_cast13, i8 0, i64 16, i1 false)
  %arr.get10.sroa.0.0..sroa_cast = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %arr.idx.get.gep9 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %arr.get10.sroa.0.0.sroa_cast13, i8 addrspace(1)* noundef align 8 dereferenceable(16) %arr.get10.sroa.0.0..sroa_cast, i64 16, i1 false)
  %arr.get10.sroa.2.0..sroa_idx11 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %12, i64 0, i32 1, i64 %13, i32 0, i32 2
  %arr.get10.sroa.2.0.copyload = load i64, i64 addrspace(1)* %arr.get10.sroa.2.0..sroa_idx11, align 8
  %sub = sub i64 %arr.get10.sroa.2.0.copyload, %arr.get.sroa.2.0.copyload
  %icmpeq = icmp eq i64 %2, 1
  br i1 %icmpeq, label %if.then16, label %if.else15

if.then16:                                        ; preds = %if.else6
  %arr.alloc.size.valid = icmp sgt i64 %sub, -1
  br i1 %arr.alloc.size.valid, label %arr.alloc.body, label %arr.alloc.throw

arr.alloc.throw:                                  ; preds = %if.then16
  %pgocount85 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 5), align 8
  %14 = add i64 %pgocount85, 1
  store i64 %14, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 5), align 8
  %15 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core26NegativeArraySizeExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core26NegativeArraySizeException4initEv"(i8 addrspace(1)* %15)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %15)
  unreachable

arr.alloc.body:                                   ; preds = %if.then16
  %pgocount86 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 1), align 8
  %16 = add i64 %pgocount86, 1
  store i64 %16, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 1), align 8
  %17 = call noalias i8 addrspace(1)* @CJ_MCC_NewArray32Stub(i64 %sub, i8* bitcast (%KlassInfo.0* @UInt32.arrayKlass to i8*))
  %18 = bitcast %_ZN07ClosureE* %closure to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %18, i8 0, i64 16, i1 false)
  %19 = getelementptr inbounds %_ZN07ClosureE, %_ZN07ClosureE* %closure, i64 0, i32 0
  store i8* bitcast (i32 (i8 addrspace(1)*, i64)* @"numeric/bigint$lambda.5" to i8*), i8** %19, align 8
  %20 = getelementptr inbounds %_ZN07ClosureE, %_ZN07ClosureE* %closure, i64 0, i32 1
  %21 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN17numeric$FS$bigint21__Auto__Environment_5E.objKlass" to i8*), i32 40)
  %22 = getelementptr inbounds i8, i8 addrspace(1)* %21, i64 8
  %23 = bitcast %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE" addrspace(1)* %arr to i8 addrspace(1)*
  call void @llvm.cj.gcwrite.struct.p1i8(i8 addrspace(1)* %21, i8 addrspace(1)* %22, i8 addrspace(1)* %23, i64 24)
  %24 = getelementptr inbounds i8, i8 addrspace(1)* %21, i64 32
  %25 = bitcast i8 addrspace(1)* %24 to i64 addrspace(1)*
  call void @llvm.cj.gcwrite.i64.i64(i64 %arr.get.sroa.2.0.copyload, i8 addrspace(1)* %21, i64 addrspace(1)* %25)
  store i8 addrspace(1)* %21, i8 addrspace(1)** %20, align 8
  %26 = addrspacecast %_ZN07ClosureE* %closure to %_ZN07ClosureE addrspace(1)*
  %27 = call fastcc i8 addrspace(1)* @"_ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE"(i8 addrspace(1)* %17, i8 addrspace(1)* null, %_ZN07ClosureE addrspace(1)* %26)
  br label %if.end14

if.else15:                                        ; preds = %if.else6
  %sub21 = add i64 %2, -1
  %28 = load i64, i64 addrspace(1)* %1, align 8
  %icmpuge24.not = icmp ult i64 %sub21, %28
  br i1 %icmpuge24.not, label %if.else26, label %if.then27

if.then27:                                        ; preds = %if.else15
  %pgocount87 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 6), align 8
  %29 = add i64 %pgocount87, 1
  store i64 %29, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 6), align 8
  %30 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %30)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %30)
  unreachable

if.else26:                                        ; preds = %if.else15
  %31 = load %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* addrspace(1)* %5, align 8
  %32 = load i64, i64 addrspace(1)* %7, align 8
  %add = add i64 %32, %sub21
  %arr.idx.get.gep29 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %31, i64 0, i32 1, i64 %add
  %arr.get30.sroa.0.0.sroa_cast23 = bitcast { i8 addrspace(1)*, i64 }* %arr.get30.sroa.0 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %arr.get30.sroa.0.0.sroa_cast23, i8 0, i64 16, i1 false)
  %arr.get30.sroa.0.0..sroa_cast = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %arr.idx.get.gep29 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %arr.get30.sroa.0.0.sroa_cast23, i8 addrspace(1)* noundef align 8 dereferenceable(16) %arr.get30.sroa.0.0..sroa_cast, i64 16, i1 false)
  %arr.get30.sroa.2.0..sroa_idx21 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %31, i64 0, i32 1, i64 %add, i32 0, i32 2
  %arr.get30.sroa.2.0.copyload = load i64, i64 addrspace(1)* %arr.get30.sroa.2.0..sroa_idx21, align 8
  %add32 = add i64 %arr.get30.sroa.2.0.copyload, 1
  %arr.alloc.size.valid37 = icmp sgt i64 %add32, -1
  br i1 %arr.alloc.size.valid37, label %arr.alloc.body35, label %arr.alloc.throw36

arr.alloc.throw36:                                ; preds = %if.else26
  %pgocount88 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 7), align 8
  %33 = add i64 %pgocount88, 1
  store i64 %33, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 7), align 8
  %34 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core26NegativeArraySizeExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core26NegativeArraySizeException4initEv"(i8 addrspace(1)* %34)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %34)
  unreachable

arr.alloc.body35:                                 ; preds = %if.else26
  %35 = call noalias i8 addrspace(1)* @CJ_MCC_NewArray32Stub(i64 %add32, i8* bitcast (%KlassInfo.0* @UInt32.arrayKlass to i8*))
  %sub39 = sub i64 %add32, %sub
  %36 = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE"* %rest to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %36, i8 0, i64 32, i1 false)
  %callRet40.sroa.0.0..sroa_idx = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %rest, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %35, i8 addrspace(1)** %callRet40.sroa.0.0..sroa_idx, align 8
  %callRet40.sroa.3.0..sroa_idx79 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %rest, i64 0, i32 0, i32 1
  store i64 0, i64* %callRet40.sroa.3.0..sroa_idx79, align 8
  %callRet40.sroa.4.0..sroa_idx80 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %rest, i64 0, i32 0, i32 2
  store i64 %add32, i64* %callRet40.sroa.4.0..sroa_idx80, align 8
  %callRet40.sroa.5.0..sroa_idx81 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %rest, i64 0, i32 1
  store i64 %sub39, i64* %callRet40.sroa.5.0..sroa_idx81, align 8
  %37 = load i64, i64 addrspace(1)* %1, align 8
  %icmpuge44 = icmp eq i64 %37, 0
  br i1 %icmpuge44, label %if.then47, label %if.else46

if.then47:                                        ; preds = %arr.alloc.body35
  %pgocount89 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 8), align 8
  %38 = add i64 %pgocount89, 1
  store i64 %38, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 8), align 8
  %39 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %39)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %39)
  unreachable

if.else46:                                        ; preds = %arr.alloc.body35
  %40 = load %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* addrspace(1)* %5, align 8
  %41 = load i64, i64 addrspace(1)* %7, align 8
  %arr.idx.get.gep49 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %40, i64 0, i32 1, i64 %41
  %42 = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE"* %arr.get50 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %42, i8 0, i64 32, i1 false)
  %43 = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %arr.idx.get.gep49 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %42, i8 addrspace(1)* noundef align 8 dereferenceable(32) %43, i64 32, i1 false)
  %44 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %arr.get50, i64 0, i32 0
  %45 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %rest, i64 0, i32 0
  %46 = addrspacecast %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE"* %44 to %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" addrspace(1)*
  %47 = addrspacecast %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE"* %45 to %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" addrspace(1)*
  call fastcc void @"_ZN17numeric$FS$bigint11std$FS$core5ArrayIj6copyToER_ZN11std$FS$core5ArrayIjElll"(%Unit.Type* noalias nonnull sret(%Unit.Type) %callRet52, i8 addrspace(1)* null, %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" addrspace(1)* %46, i8 addrspace(1)* null, %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" addrspace(1)* %47, i64 %arr.get.sroa.2.0.copyload, i64 %sub39, i64 %sub)
  %48 = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE"* %callRet88 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %48, i8 0, i64 32, i1 false)
  %arr.get86.sroa.0.0.sroa_cast45 = bitcast %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE"* %arr.get86.sroa.0 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %arr.get86.sroa.0.0.sroa_cast45, i8 0, i64 24, i1 false)
  %arr.get76.sroa.0.0.sroa_cast41 = bitcast { i8 addrspace(1)*, i64 }* %arr.get76.sroa.0 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull %arr.get76.sroa.0.0.sroa_cast41, i8 0, i64 16, i1 false)
  %49 = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE"* %arr.get67 to i8*
  call void @llvm.cj.memset.p0i8(i8* nonnull align 8 %49, i8 0, i64 32, i1 false)
  %icmpslt82 = icmp sgt i64 %2, 1
  br i1 %icmpslt82, label %while.body.preheader, label %block.end

while.body.preheader:                             ; preds = %if.else46
  %50 = addrspacecast %"T2_R_ZN11std$FS$core5ArrayIjElE"* %rest to %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*
  %51 = addrspacecast %"T2_R_ZN11std$FS$core5ArrayIjElE"* %arr.get67 to %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*
  br label %while.body

while.body:                                       ; preds = %while.body.preheader, %if.else81
  %atom55.083 = phi i64 [ %add58, %if.else81 ], [ 1, %while.body.preheader ]
  %52 = load i64, i64 addrspace(1)* %1, align 8
  %icmpuge60.not = icmp ult i64 %atom55.083, %52
  br i1 %icmpuge60.not, label %if.else81, label %if.then63

if.then63:                                        ; preds = %while.body
  %pgocount90 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 9), align 8
  %53 = add i64 %pgocount90, 1
  store i64 %53, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 9), align 8
  %54 = call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %54)
  call void @CJ_MCC_ThrowException(i8 addrspace(1)* %54)
  unreachable

if.else81:                                        ; preds = %while.body
  %add58 = add nuw nsw i64 %atom55.083, 1
  %55 = load %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* addrspace(1)* %5, align 8
  %56 = load i64, i64 addrspace(1)* %7, align 8
  %add65 = add i64 %56, %atom55.083
  %arr.idx.get.gep66 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %55, i64 0, i32 1, i64 %add65
  %57 = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %arr.idx.get.gep66 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %49, i8 addrspace(1)* noundef align 8 dereferenceable(32) %57, i64 32, i1 false)
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %arr.get76.sroa.0.0.sroa_cast41, i8 addrspace(1)* noundef align 8 dereferenceable(16) %57, i64 16, i1 false)
  %pgocount93 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 0), align 8
  %58 = add i64 %pgocount93, 1
  store i64 %58, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 0), align 8
  %arr.get76.sroa.2.0..sroa_idx39 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %55, i64 0, i32 1, i64 %add65, i32 0, i32 2
  %arr.get76.sroa.2.0.copyload = load i64, i64 addrspace(1)* %arr.get76.sroa.2.0..sroa_idx39, align 8
  %59 = load %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* addrspace(1)* %5, align 8
  %arr.idx.get.gep85 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %59, i64 0, i32 1, i64 %add65
  %arr.get86.sroa.0.0..sroa_cast = bitcast %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %arr.idx.get.gep85 to i8 addrspace(1)*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %arr.get86.sroa.0.0.sroa_cast45, i8 addrspace(1)* noundef align 8 dereferenceable(24) %arr.get86.sroa.0.0..sroa_cast, i64 24, i1 false)
  %arr.get86.sroa.2.0..sroa_idx44 = getelementptr inbounds %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE", %"ArrayLayout.T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %59, i64 0, i32 1, i64 %add65, i32 1
  %arr.get86.sroa.2.0.copyload = load i64, i64 addrspace(1)* %arr.get86.sroa.2.0..sroa_idx44, align 8
  %sub87 = sub i64 %arr.get76.sroa.2.0.copyload, %arr.get86.sroa.2.0.copyload
  call fastcc void @"_ZN17numeric$FS$bigint6BigInt7addDMutET2_R_ZN11std$FS$core5ArrayIjElET2_R_ZN11std$FS$core5ArrayIjElEl"(%"T2_R_ZN11std$FS$core5ArrayIjElE"* noalias nonnull sret(%"T2_R_ZN11std$FS$core5ArrayIjElE") %callRet88, i8 addrspace(1)* null, %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %50, i8 addrspace(1)* null, %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)* %51, i64 %sub87)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %36, i8* noundef nonnull align 8 dereferenceable(32) %48, i64 32, i1 false)
  %exitcond.not = icmp eq i64 %add58, %2
  br i1 %exitcond.not, label %block.end, label %while.body

block.end:                                        ; preds = %if.else81, %if.else46
  %pgocount94 = load i64, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 2), align 8
  %60 = add i64 %pgocount94, 1
  store i64 %60, i64* getelementptr inbounds ([12 x i64], [12 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint6BigInt10sumOrderedER_ZN11std$FS$core5ArrayIT2_R_ZN11std$FS$core5ArrayIjElEE", i64 0, i64 2), align 8
  %ifvalue13.sroa.0.0.copyload59 = load i8 addrspace(1)*, i8 addrspace(1)** %callRet40.sroa.0.0..sroa_idx, align 8
  %ifvalue13.sroa.4.0.copyload62 = load i64, i64* %callRet40.sroa.3.0..sroa_idx79, align 8
  %ifvalue13.sroa.5.0.copyload65 = load i64, i64* %callRet40.sroa.4.0..sroa_idx80, align 8
  %ifvalue13.sroa.6.0.copyload68 = load i64, i64* %callRet40.sroa.5.0..sroa_idx81, align 8
  br label %if.end14

if.end14:                                         ; preds = %block.end, %arr.alloc.body
  %ifvalue13.sroa.0.0 = phi i8 addrspace(1)* [ %17, %arr.alloc.body ], [ %ifvalue13.sroa.0.0.copyload59, %block.end ]
  %ifvalue13.sroa.4.0 = phi i64 [ 0, %arr.alloc.body ], [ %ifvalue13.sroa.4.0.copyload62, %block.end ]
  %ifvalue13.sroa.5.0 = phi i64 [ %sub, %arr.alloc.body ], [ %ifvalue13.sroa.5.0.copyload65, %block.end ]
  %ifvalue13.sroa.6.0 = phi i64 [ 0, %arr.alloc.body ], [ %ifvalue13.sroa.6.0.copyload68, %block.end ]
  %ifvalue13.sroa.0.0..sroa_idx = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %0, i64 0, i32 0, i32 0
  store i8 addrspace(1)* %ifvalue13.sroa.0.0, i8 addrspace(1)** %ifvalue13.sroa.0.0..sroa_idx, align 8
  %ifvalue13.sroa.4.0..sroa_idx60 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %0, i64 0, i32 0, i32 1
  store i64 %ifvalue13.sroa.4.0, i64* %ifvalue13.sroa.4.0..sroa_idx60, align 8
  %ifvalue13.sroa.5.0..sroa_idx63 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %0, i64 0, i32 0, i32 2
  store i64 %ifvalue13.sroa.5.0, i64* %ifvalue13.sroa.5.0..sroa_idx63, align 8
  %ifvalue13.sroa.6.0..sroa_idx66 = getelementptr inbounds %"T2_R_ZN11std$FS$core5ArrayIjElE", %"T2_R_ZN11std$FS$core5ArrayIjElE"* %0, i64 0, i32 1
  store i64 %ifvalue13.sroa.6.0, i64* %ifvalue13.sroa.6.0..sroa_idx66, align 8
  ret void
}

define internal fastcc i8 addrspace(1)* @"_ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE"(i8 addrspace(1)* returned %array, i8 addrspace(1)* nocapture readnone %"initElement$BP", %_ZN07ClosureE addrspace(1)* nocapture readonly %initElement) unnamed_addr #13 gc "cangjie" personality i32 (...)* @"__cj_personality_v0$" {
entry:
  %pgocount = load i64, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 1), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 1), align 8
  %1 = getelementptr inbounds i8, i8 addrspace(1)* %array, i64 8
  %2 = bitcast i8 addrspace(1)* %1 to i64 addrspace(1)*
  %3 = load i64, i64 addrspace(1)* %2, align 8
  %icmpslt4 = icmp sgt i64 %3, 0
  br i1 %icmpslt4, label %while.body.preheader, label %block.end

while.body.preheader:                             ; preds = %entry
  %4 = bitcast %_ZN07ClosureE addrspace(1)* %initElement to i32 (i8 addrspace(1)*, i64)* addrspace(1)*
  %5 = getelementptr inbounds %_ZN07ClosureE, %_ZN07ClosureE addrspace(1)* %initElement, i64 0, i32 1
  %6 = bitcast i8 addrspace(1)* %array to %ArrayLayout.UInt32 addrspace(1)*
  br label %while.body

while.body:                                       ; preds = %while.body.preheader, %arr.if.else
  %pgocount78 = phi i64 [ %15, %arr.if.else ], [ 0, %while.body.preheader ]
  %7 = load i32 (i8 addrspace(1)*, i64)*, i32 (i8 addrspace(1)*, i64)* addrspace(1)* %4, align 8
  %8 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %5, align 8
  %9 = ptrtoint i32 (i8 addrspace(1)*, i64)* %7 to i64
  tail call void @__llvm_profile_instrument_target(i64 %9, i8* bitcast ({ i64, i64, i64, i8*, i8*, i32, [2 x i16] }* @"__profd_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE" to i8*), i32 0)
  %10 = tail call i32 %7(i8 addrspace(1)* %8, i64 %pgocount78)
  %11 = load i64, i64 addrspace(1)* %2, align 8
  %.not = icmp slt i64 %pgocount78, %11
  br i1 %.not, label %arr.if.else, label %arr.if.then

arr.if.then:                                      ; preds = %while.body
  %pgocount.promoted = load i64, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 0), align 8
  %12 = add i64 %pgocount.promoted, %pgocount78
  store i64 %12, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 0), align 8
  %pgocount6 = load i64, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 2), align 8
  %13 = add i64 %pgocount6, 1
  store i64 %13, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 2), align 8
  %14 = tail call noalias i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8* bitcast (%KlassInfo.0* @"_ZN11std$FS$core25IndexOutOfBoundsExceptionE.objKlass" to i8*), i32 56)
  tail call void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)* %14)
  tail call void @CJ_MCC_ThrowException(i8 addrspace(1)* %14)
  unreachable

arr.if.else:                                      ; preds = %while.body
  %15 = add nuw nsw i64 %pgocount78, 1
  %arr.idx.set.gep = getelementptr inbounds %ArrayLayout.UInt32, %ArrayLayout.UInt32 addrspace(1)* %6, i64 0, i32 1, i64 %pgocount78
  tail call void @llvm.cj.gcwrite.i32.i32(i32 %10, i8 addrspace(1)* %array, i32 addrspace(1)* %arr.idx.set.gep)
  %16 = load i64, i64 addrspace(1)* %2, align 8
  %icmpslt = icmp slt i64 %15, %16
  br i1 %icmpslt, label %while.body, label %block.body.block.end_crit_edge

block.body.block.end_crit_edge:                   ; preds = %arr.if.else
  %pgocount.promoted9 = load i64, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 0), align 8
  %17 = add i64 %pgocount.promoted9, %15
  store i64 %17, i64* getelementptr inbounds ([3 x i64], [3 x i64]* @"__profc_numeric_bigint__ZN17numeric$FS$bigint11std$FS$core19arrayInitByFunctionIjEA1_jEC_ZN017$LambdaCommon_1jlE", i64 0, i64 0), align 8
  br label %block.end

block.end:                                        ; preds = %block.body.block.end_crit_edge, %entry
  ret i8 addrspace(1)* %array
}

declare i8 addrspace(1)* @llvm.cj.heapmalloc.class(i8*, i32)

declare void @"_ZN11std$FS$core25IndexOutOfBoundsException4initEv"(i8 addrspace(1)*) gc "cangjie"

declare void @CJ_MCC_ThrowException(i8 addrspace(1)*)

declare void @"_ZN11std$FS$core26NegativeArraySizeException4initEv"(i8 addrspace(1)*) gc "cangjie"

declare void @"T2_R_ZN11std$FS$core5ArrayIjElE.create"(%"T2_R_ZN11std$FS$core5ArrayIjElE"* noalias sret(%"T2_R_ZN11std$FS$core5ArrayIjElE"), i8 addrspace(1)*, %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" addrspace(1)*, i64) gc "cangjie"

declare void @"_ZN17numeric$FS$bigint11std$FS$core5ArrayIj6copyToER_ZN11std$FS$core5ArrayIjElll"(%Unit.Type* noalias sret(%Unit.Type), i8 addrspace(1)*, %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" addrspace(1)*, i8 addrspace(1)*, %"record._ZN17numeric$FS$bigint11std$FS$core5ArrayIjE" addrspace(1)*, i64, i64, i64) gc "cangjie"

declare void @"_ZN17numeric$FS$bigint6BigInt7addDMutET2_R_ZN11std$FS$core5ArrayIjElET2_R_ZN11std$FS$core5ArrayIjElEl"(%"T2_R_ZN11std$FS$core5ArrayIjElE"* noalias sret(%"T2_R_ZN11std$FS$core5ArrayIjElE"), i8 addrspace(1)*, %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, i8 addrspace(1)*, %"T2_R_ZN11std$FS$core5ArrayIjElE" addrspace(1)*, i64) gc "cangjie"

declare i32 @"__cj_personality_v0$"(...)

declare i8 addrspace(1)* @llvm.cj.gcmalloc.array(i64, i8*)

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.struct.p1i8(i8 addrspace(1)*, i8 addrspace(1)* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64)

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.i32.i32(i32, i8 addrspace(1)* nocapture, i32 addrspace(1)* nocapture)

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.i64.i64(i64, i8 addrspace(1)* nocapture, i64 addrspace(1)* nocapture)

; Function Attrs: nounwind
declare void @llvm.cj.memset.p0i8(i8*, i8, i64, i1)

; Function Attrs: argmemonly nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)

; Function Attrs: argmemonly nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg)

declare i32 @"numeric/bigint$lambda.5"(i8 addrspace(1)*, i64) gc "cangjie"

declare i8 addrspace(1)* @CJ_MCC_NewArray32Stub(i64, i8*)

declare i8 addrspace(1)* @CJ_MCC_NewObjectStub(i8*, i32)

declare void @__llvm_profile_instrument_target(i64, i8*, i32) local_unnamed_addr
