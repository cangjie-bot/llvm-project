; RUN: opt --passes='instcombine' --cangjie-pipeline -S < %s | FileCheck %s

%ObjLayout.Object = type { i8* }
%"ObjLayout._ZN11std$FS$core6ObjectE" = type { %ObjLayout.Object }
%record._ZN7default24Struct_1694636776828_218E = type { i8 addrspace(1)* }
%"ObjLayout._ZN7default11$Auto_Env$0E" = type { %"ObjLayout._ZN11std$FS$core6ObjectE", %record._ZN7default24Struct_1694636776828_218E }

@_ZN7default4stepE = internal global i64 2, align 8

declare i64 @"_ZN11std$FS$core6Extendl4nextEl"(i64, i64) gc "cangjie"

define void @_ZN7default4mainEv(%record._ZN7default24Struct_1694636776828_218E* sret(%record._ZN7default24Struct_1694636776828_218E) %0, i8 addrspace(1)* %"$env") #1 gc "cangjie" {
; CHECK-LABEL: @_ZN7default4mainEv(
; CHECK-LABEL: entry
; CHECK-NEXT: %1 = bitcast i8 addrspace(1)* %"$env" to %"ObjLayout._ZN7default11$Auto_Env$0E" addrspace(1)*
; CHECK-NEXT: %2 = getelementptr inbounds %"ObjLayout._ZN7default11$Auto_Env$0E", %"ObjLayout._ZN7default11$Auto_Env$0E" addrspace(1)* %1, i64 0, i32 1, i32 0
; CHECK-NEXT: %3 = getelementptr inbounds %record._ZN7default24Struct_1694636776828_218E, %record._ZN7default24Struct_1694636776828_218E* %0, i64 0, i32 0
; CHECK-NEXT: %4 = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %2, align 8
; CHECK-NEXT: store i8 addrspace(1)* %4, i8 addrspace(1)** %3, align 8
entry:
  %1 = bitcast i8 addrspace(1)* %"$env" to %"ObjLayout._ZN7default11$Auto_Env$0E" addrspace(1)*
  %2 = getelementptr inbounds %"ObjLayout._ZN7default11$Auto_Env$0E", %"ObjLayout._ZN7default11$Auto_Env$0E" addrspace(1)* %1, i32 0, i32 1
  %3 = bitcast %record._ZN7default24Struct_1694636776828_218E addrspace(1)* %2 to i8 addrspace(1)*
  %4 = bitcast %record._ZN7default24Struct_1694636776828_218E* %0 to i8*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 8 %4, i8 addrspace(1)* align 8 %3, i64 8, i1 false)
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.i1.i1(i1, i8 addrspace(1)* nocapture, i1 addrspace(1)* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.cj.gcwrite.i64.i64(i64, i8 addrspace(1)* nocapture, i64 addrspace(1)* nocapture) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.sadd.sat.i64(i64, i64) #5

; Function Attrs: nounwind
declare void @llvm.cj.memset(i8*, i8, i64, i1) #6

; Function Attrs: argmemonly nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg)

attributes #0 = { "cj_fast_call" "hasRcdParam" "record_mut" }
attributes #1 = { "cjinit" }
attributes #2 = { argmemonly nounwind }
attributes #3 = { argmemonly nofree nosync nounwind willreturn }
attributes #4 = { argmemonly nofree nosync nounwind willreturn writeonly }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }
