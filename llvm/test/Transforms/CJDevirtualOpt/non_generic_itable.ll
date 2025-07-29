; RUN: opt '-passes=cj-devirtual-opt' --cangjie-pipeline -S < %s | FileCheck %s

%TypeInfo = type { i8*, i8, i8, i16, i32, i8*, i32, i8, i8, i16, i32*, i8*, i8*, i8*, %TypeInfo*, %ExtensionDef**, i8*, i8* }
%ExtensionDef = type { i32, i8, i8*, i8*, i8*, i8* }

@"std.core:Object.ti" = external global %TypeInfo
@"default:A.ti" = internal global %TypeInfo { i8* null, i8 -128, i8 0, i16 0, i32 0, i8* null, i32 0, i8 1, i8 0, i16 1, i32* null, i8* null, i8* null, i8* null, %TypeInfo* @"std.core:Object.ti", %ExtensionDef** getelementptr inbounds ([2 x %ExtensionDef*], [2 x %ExtensionDef*]* @NonExternalExtensionDefs, i32 0, i32 0), i8* null, i8* null } #0
@"default:I1.ti" = internal global %TypeInfo { i8* null, i8 -127, i8 0, i16 0, i32 0, i8* null, i32 0, i8 1, i8 0, i16 0, i32* null, i8* null, i8* null, i8* null, %TypeInfo* null, %ExtensionDef** null, i8* null, i8* null } #0
@"default:A_ed_default:I1.ft" = internal global [1 x i8*] [i8* bitcast (i64 (i8 addrspace(1)*, %TypeInfo*)* @test_func_A to i8*)]
@"default:A_ed_default:I1" = internal global %ExtensionDef { i32 0, i8 1, i8* bitcast (%TypeInfo* @"default:A.ti" to i8*), i8* bitcast (%TypeInfo* @"default:I1.ti" to i8*), i8* null, i8* bitcast ([1 x i8*]* @"default:A_ed_default:I1.ft" to i8*) }

@NonExternalExtensionDefs = internal global [2 x %ExtensionDef*] [%ExtensionDef* @"default:A_ed_default:I1", %ExtensionDef* null]

; CHECK: [[TMP0:%.*]] = bitcast i8* bitcast (i64 (i8 addrspace(1)*, %TypeInfo*)* @test_func_A to i8*) to i64 (i8 addrspace(1)*, %TypeInfo*)*
; CHECK-NEXT: call i64 [[TMP0]](i8 addrspace(1)* [[TMP1:%.*]], %TypeInfo* [[TMP2:%.*]])
define internal i64 @callee(i8 addrspace(1)* %ptr) {
  %1 = bitcast i8 addrspace(1)* %ptr to %TypeInfo* addrspace(1)*
  %2 = load %TypeInfo*, %TypeInfo* addrspace(1)* %1, align 8
  %3 = bitcast %TypeInfo* %2 to i8*
  %4 = call i8* @CJ_MCC_GetMTable(i8* %3, i8* bitcast (%TypeInfo* @"default:I1.ti" to i8*))
  %5 = bitcast i8* %4 to i8**
  %6 = getelementptr i8*, i8** %5, i32 0
  %7 = load i8*, i8** %6, !FuncTable !0
  %8 = bitcast i8* %7 to i64 (i8 addrspace(1)*, %TypeInfo*)*
  %9 = call i64 %8(i8 addrspace(1)* %ptr, %TypeInfo* %2)
  ret i64 %9
}

define void @caller() {
  %1 = call noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8* bitcast (%TypeInfo* @"default:A.ti" to i8*), i32 8)
  %2 = call i64 @callee(i8 addrspace(1)* %1)
  ret void
}

define internal i64 @test_func_A(i8 addrspace(1)* %this, %TypeInfo* %outerTI) {
  ret i64 0
}

declare i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32)
declare i8* @CJ_MCC_GetMTable(i8*, i8*)

attributes #0 = { "CFileKlass" }

!0 = !{i64 0}
