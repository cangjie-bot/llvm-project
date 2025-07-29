; RUN: opt --cangjie-pipeline -O2 -S < %s | FileCheck %s

%"record._ZN7default11std$FS$core6OptionIlE" = type { i1, i64 }
%record._ZN7default7default19StructRangeIteratorIlE = type { i64, i64, i64, i1 }

@_ZN7default4stepE = internal global i64 2, align 8

declare i64 @"_ZN11std$FS$core6Extendl4nextEl"(i64, i64) gc "cangjie"

define internal void @_ZN7default7default19StructRangeIteratorIl4nextEv(%"record._ZN7default11std$FS$core6OptionIlE"* noalias sret(%"record._ZN7default11std$FS$core6OptionIlE") %0, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i8 addrspace(1)* %BP) #0 gc "cangjie" {
entry:
  %enum.val1 = alloca %"record._ZN7default11std$FS$core6OptionIlE", align 8
  %enum.val = alloca %"record._ZN7default11std$FS$core6OptionIlE", align 8
  %res = alloca i64, align 8
  br label %thunk19E

thunk19E:                                         ; preds = %entry
  %1 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i32 0, i32 2
  %2 = load i64, i64 addrspace(1)* %1, align 8
  store i64 %2, i64* %res, align 8
  %3 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i32 0, i32 3
  %4 = load i1, i1 addrspace(1)* %3, align 1
  br i1 %4, label %if.then57E, label %if.else57E

if.then57E:                                       ; preds = %thunk19E
  %5 = load i64, i64* %res, align 8
  %6 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i32 0, i32 0
  %7 = load i64, i64 addrspace(1)* %6, align 8
  %icmpne = icmp ne i64 %5, %7
  %8 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i32 0, i32 3
  store i1 %icmpne, i1 addrspace(1)* %8, align 1
  %9 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i32 0, i32 2
  %10 = load i64, i64 addrspace(1)* %9, align 8
  %11 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i32 0, i32 1
  %12 = load i64, i64 addrspace(1)* %11, align 8
  %13 = call i64 @"_ZN11std$FS$core6Extendl4nextEl"(i64 %10, i64 %12)
  %14 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %this, i32 0, i32 2
  store i64 %13, i64 addrspace(1)* %14, align 8
  %15 = load i64, i64* %res, align 8
  %16 = getelementptr inbounds %"record._ZN7default11std$FS$core6OptionIlE", %"record._ZN7default11std$FS$core6OptionIlE"* %enum.val, i32 0, i32 0
  store i1 false, i1* %16, align 1
  %17 = getelementptr inbounds %"record._ZN7default11std$FS$core6OptionIlE", %"record._ZN7default11std$FS$core6OptionIlE"* %enum.val, i32 0, i32 1
  store i64 %15, i64* %17, align 8
  %18 = bitcast %"record._ZN7default11std$FS$core6OptionIlE"* %0 to i8*
  %19 = bitcast %"record._ZN7default11std$FS$core6OptionIlE"* %enum.val to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %18, i8* align 8 %19, i64 16, i1 false)
  ret void

if.else57E:                                       ; preds = %thunk19E
  br label %if.end57E

if.end57E:                                        ; preds = %if.else57E
  %20 = getelementptr inbounds %"record._ZN7default11std$FS$core6OptionIlE", %"record._ZN7default11std$FS$core6OptionIlE"* %enum.val1, i32 0, i32 0
  store i1 true, i1* %20, align 1
  %21 = getelementptr inbounds %"record._ZN7default11std$FS$core6OptionIlE", %"record._ZN7default11std$FS$core6OptionIlE"* %enum.val1, i32 0, i32 1
  store i64 0, i64* %21, align 8
  %22 = bitcast %"record._ZN7default11std$FS$core6OptionIlE"* %0 to i8*
  %23 = bitcast %"record._ZN7default11std$FS$core6OptionIlE"* %enum.val1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %22, i8* align 8 %23, i64 16, i1 false)
  ret void
}

define i64 @_ZN7default4mainEv() #1 gc "cangjie" {
; CHECK-LABEL: @_ZN7default4mainEv(
; CHECK-LABEL: entry
; CHECK-NOT: %iter = alloca %record._ZN7default7default19StructRangeIteratorIlE, align 8
entry:
  %v = alloca i64, align 8
  %callRet = alloca %"record._ZN7default11std$FS$core6OptionIlE", align 8
  %iter = alloca %record._ZN7default7default19StructRangeIteratorIlE, align 8
  %step = alloca i64, align 8
  %0 = alloca %record._ZN7default7default19StructRangeIteratorIlE, align 8
  %atom.187E = alloca %record._ZN7default7default19StructRangeIteratorIlE, align 8
  %atom.189E = alloca i64, align 8
  br label %thunk96E

thunk96E:                                         ; preds = %entry
  store i64 0, i64* %atom.189E, align 8
  %1 = bitcast %record._ZN7default7default19StructRangeIteratorIlE* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %1, i8 0, i64 32, i1 false)
  %2 = bitcast %record._ZN7default7default19StructRangeIteratorIlE* %atom.187E to i8*
  %3 = bitcast %record._ZN7default7default19StructRangeIteratorIlE* %0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %2, i8* align 8 %3, i64 32, i1 false)
  %4 = load i64, i64* @_ZN7default4stepE, align 8
  store i64 %4, i64* %step, align 8
  %5 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE* %atom.187E, i32 0, i32 0
  store i64 1000000000, i64* %5, align 8
  %6 = load i64, i64* %step, align 8
  %7 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE* %atom.187E, i32 0, i32 1
  store i64 %6, i64* %7, align 8
  %8 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE* %atom.187E, i32 0, i32 2
  store i64 0, i64* %8, align 8
  %9 = getelementptr inbounds %record._ZN7default7default19StructRangeIteratorIlE, %record._ZN7default7default19StructRangeIteratorIlE* %atom.187E, i32 0, i32 3
  store i1 true, i1* %9, align 1
  %10 = bitcast %record._ZN7default7default19StructRangeIteratorIlE* %iter to i8*
  %11 = bitcast %record._ZN7default7default19StructRangeIteratorIlE* %atom.187E to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %10, i8* align 8 %11, i64 32, i1 false)
  br label %block.body126E

block.body126E:                                   ; preds = %if.end160E, %thunk96E
  %12 = addrspacecast %record._ZN7default7default19StructRangeIteratorIlE* %iter to %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)*
  call void @_ZN7default7default19StructRangeIteratorIl4nextEv(%"record._ZN7default11std$FS$core6OptionIlE"* noalias sret(%"record._ZN7default11std$FS$core6OptionIlE") %callRet, %record._ZN7default7default19StructRangeIteratorIlE addrspace(1)* %12, i8 addrspace(1)* null)
  %13 = getelementptr inbounds %"record._ZN7default11std$FS$core6OptionIlE", %"record._ZN7default11std$FS$core6OptionIlE"* %callRet, i32 0, i32 0
  %14 = load i1, i1* %13, align 1
  %icmpeq = icmp eq i1 %14, false
  br i1 %icmpeq, label %if.then160E, label %if.else160E

if.then160E:                                      ; preds = %block.body126E
  %15 = getelementptr inbounds %"record._ZN7default11std$FS$core6OptionIlE", %"record._ZN7default11std$FS$core6OptionIlE"* %callRet, i32 0, i32 1
  %16 = load i64, i64* %15, align 8
  store i64 %16, i64* %v, align 8
  %17 = load i64, i64* %atom.189E, align 8
  %18 = load i64, i64* %v, align 8
  %19 = call i64 @llvm.sadd.sat.i64(i64 %17, i64 %18)
  store i64 %19, i64* %atom.189E, align 8
  br label %if.end160E

if.else160E:                                      ; preds = %block.body126E
  br label %block.end126E

if.end160E:                                       ; preds = %if.then160E
  br label %block.body126E

block.end126E:                                    ; preds = %if.else160E
  %20 = load i64, i64* %atom.189E, align 8
  ret i64 %20
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.sadd.sat.i64(i64, i64) #5

; Function Attrs: nounwind
declare void @llvm.cj.memset(i8*, i8, i64, i1) #6

attributes #0 = { "cj_fast_call" "hasRcdParam" "record_mut" }
attributes #1 = { "cjinit" }
attributes #2 = { argmemonly nounwind }
attributes #3 = { argmemonly nofree nosync nounwind willreturn }
attributes #4 = { argmemonly nofree nosync nounwind willreturn writeonly }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }
