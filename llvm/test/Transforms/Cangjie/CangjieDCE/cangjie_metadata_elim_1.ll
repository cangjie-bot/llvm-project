; RUN: opt < %s -passes='globaldce' --cangjie-pipeline -S | FileCheck %s

%TypeTemplate = type { i8*, i8, i8, i16, i16, i8*, i8*, i8*, i8*, %ExtensionDef**, i16 }
%ExtensionDef = type { i32, i8, i8*, i8*, i8*, i8* }
%TypeInfo = type { i8*, i8, i8, i16, i32, i8*, i32, i8, i8, i16, i32*, i8*, i8*, i8*, %TypeInfo*, %ExtensionDef**, i8*, i8* }

@Int32.ti = external global %TypeInfo #0
@"std.core:Object.ti" = external global %TypeInfo #0
@"A:I1.ti" = external global %TypeInfo #0

; CHECK-NOT: @"default:A.tt"
; CHECK-NOT: @"default:A.name"
; CHECK-NOT: @"default:A<Int32>.name"
; CHECK-NOT: @"default:A<Int32>.ti"
; CHECK-NOT: @"default:A<Int32>.ti.typeArgs"
; CHECK-NOT: @"default:A<T>_ed_A:I1"
@"default:A.tt" = internal global %TypeTemplate { i8* getelementptr inbounds ([10 x i8], [10 x i8]* @"default:A.name", i32 0, i32 0), i8 -128, i8 0, i16 0, i16 1, i8* null, i8* null, i8* null, i8* null, %ExtensionDef** getelementptr inbounds ([2 x %ExtensionDef*], [2 x %ExtensionDef*]* @NonExternalExtensionDefs, i32 0, i32 0), i16 -32768 } #1
@"default:I2.tt" = global %TypeTemplate { i8* getelementptr inbounds ([11 x i8], [11 x i8]* @"default:I2.name", i32 0, i32 0), i8 -127, i8 0, i16 0, i16 1, i8* null, i8* null, i8* null, i8* null, %ExtensionDef** null, i16 -32768 } #1
@"default:I2.name" = private global [11 x i8] c"default:I2\00", align 1 #3
@"default:A.name" = private global [10 x i8] c"default:A\00", align 1 #3
@"default:A<Int32>.name" = private global [17 x i8] c"default:A<Int32>\00", align 1 #3
@"default:A<Int32>.ti" = internal global %TypeInfo { i8* getelementptr inbounds ([17 x i8], [17 x i8]* @"default:A<Int32>.name", i32 0, i32 0), i8 -128, i8 0, i16 0, i32 0, i8* null, i32 0, i8 1, i8 1, i16 -32768, i32* null, i8* bitcast (%TypeTemplate* @"default:A.tt" to i8*), i8* bitcast ([1 x %TypeInfo*]* @"default:A<Int32>.ti.typeArgs" to i8*), i8* null, %TypeInfo* @"std.core:Object.ti", %ExtensionDef** getelementptr inbounds ([2 x %ExtensionDef*], [2 x %ExtensionDef*]* @NonExternalExtensionDefs, i32 0, i32 0), i8* inttoptr (i64 -9223372036854775807 to i8*), i8* null } #0
@"default:A<Int32>.ti.typeArgs" = private global [1 x %TypeInfo*] [%TypeInfo* @Int32.ti] #2
@"default:A<T>_ed_A:I1" = private global %ExtensionDef { i32 1, i8 1, i8* bitcast (%TypeTemplate* @"default:A.tt" to i8*), i8* bitcast (%TypeInfo* @"A:I1.ti" to i8*), i8* null, i8* null } #5
; CHECK: @NonExternalExtensionDefs = private global [2 x %ExtensionDef*] zeroinitializer
@NonExternalExtensionDefs = private global [2 x %ExtensionDef*] [%ExtensionDef* @"default:A<T>_ed_A:I1", %ExtensionDef* null] #4
; CHECK: @StaticGenericTIs = private global [1 x %TypeInfo*] zeroinitializer
@StaticGenericTIs = private global [1 x %TypeInfo*] [%TypeInfo* @"default:A<Int32>.ti"] #6
; CHECK: @llvm.used = appending global [2 x i8*] [i8* bitcast ([2 x %ExtensionDef*]* @NonExternalExtensionDefs to i8*), i8* bitcast ([1 x %TypeInfo*]* @StaticGenericTIs to i8*)], section "llvm.metadata"
@llvm.used = appending global [2 x i8*] [i8* bitcast ([2 x %ExtensionDef*]* @NonExternalExtensionDefs to i8*), i8* bitcast ([1 x %TypeInfo*]* @StaticGenericTIs to i8*)], section "llvm.metadata"

attributes #0 = { "CFileKlass" }
attributes #1 = { "cj_tt" }
attributes #2 = { "CJTITypeArgs" }
attributes #3 = { "CJTypeName" }
attributes #4 = { "InnerTypeExtensions" }
attributes #5 = { "CFileMTable" }
attributes #6 = { "CFileStaticGenericTI" }