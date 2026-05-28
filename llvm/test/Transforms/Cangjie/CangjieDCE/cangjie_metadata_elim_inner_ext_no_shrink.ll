; RUN: opt < %s -passes='globaldce' --cangjie-pipeline -S | FileCheck %s

%TypeInfo = type { i8*, i8, i8, i16, i32, i8*, i32, i8, i8, i16, i32*, i8*, i8*, i8*, %TypeInfo*, %ExtensionDef**, i8*, i8* }
%ExtensionDef = type { i32, i8, i8, i16, i8*, i8*, i8*, i8* }

@"default:I.ti" = external global %TypeInfo #0
@"live.ti" = global %TypeInfo { i8* null, i8 -128, i8 0, i16 0, i32 0, i8* null, i32 0, i8 1, i8 0, i16 -32768, i32* null, i8* null, i8* null, i8* null, %TypeInfo* null, %ExtensionDef** getelementptr inbounds ([2 x %ExtensionDef*], [2 x %ExtensionDef*]* @NonExternalExtensionDefs, i32 0, i32 0), i8* null, i8* null } #0
@"live.ed" = private global %ExtensionDef { i32 1, i8 1, i8 0, i16 0, i8* bitcast (%TypeInfo* @"live.ti" to i8*), i8* bitcast (%TypeInfo* @"default:I.ti" to i8*), i8* null, i8* null } #1
; CHECK: @live.ti = global %TypeInfo {{.*}}%ExtensionDef** getelementptr inbounds ([2 x %ExtensionDef*], [2 x %ExtensionDef*]* @NonExternalExtensionDefs, i32 0, i32 0){{.*}} #0
; CHECK: @NonExternalExtensionDefs = private global [2 x %ExtensionDef*] [%ExtensionDef* @live.ed, %ExtensionDef* null] #2
; CHECK: @llvm.used = appending global [1 x i8*] [i8* bitcast ([2 x %ExtensionDef*]* @NonExternalExtensionDefs to i8*)], section "llvm.metadata"
@NonExternalExtensionDefs = private global [2 x %ExtensionDef*] [%ExtensionDef* @"live.ed", %ExtensionDef* null] #2
@llvm.used = appending global [1 x i8*] [i8* bitcast ([2 x %ExtensionDef*]* @NonExternalExtensionDefs to i8*)], section "llvm.metadata"

attributes #0 = { "CFileKlass" }
attributes #1 = { "CFileMTable" }
attributes #2 = { "InnerTypeExtensions" }
