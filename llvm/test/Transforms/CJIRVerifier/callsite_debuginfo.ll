; RUN: not not opt -passes=cj-ir-verifier < %s -disable-output 2>&1 | FileCheck %s -check-prefixes=CHECK,ABORT

%record = type { i64, i8 addrspace(1)* }

; CHECK: The callsite debug info must have a !dbg location.
; CHECK-NEXT: call void @method(%record* noalias sret(%record) %callRet, i32 0, i64 1)
; CHECK-NEXT: in function foo

define void @foo() gc "cangjie" !dbg !31 {
entry:
  %callRet = alloca %record, align 8
  %0 = bitcast %record* %callRet to i8*
  call void @llvm.cj.memset(i8* align 8 %0, i8 0, i64 16, i1 false)
  call void @method(%record* noalias sret(%record) %callRet, i32 0, i64 1)
  ret void
}

; ABORT: LLVM ERROR: Broken function found, compilation aborted
; ABORT: error: Aborted

declare void @llvm.cj.memset(i8*, i8, i64, i1) #10

define void @method(%record* noalias sret(%record), i32 %0, i64 %1) gc "cangjie" {
entry:
  %3 = alloca i64, align 8
  ret void
}

!llvm.module.flags = !{!4, !5}
!llvm.dbg.cu = !{!6}

!1 = !{}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 2, !"Dwarf Version", i32 4}
!6 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !7, producer: "Cangjie Compiler", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !1)
!7 = !DIFile(filename: "default", directory: "/")
!9 = !DIFile(filename: "", directory: ".")
!10 = !DINamespace(name: "default", scope: null)
!11 = !DISubroutineType(types: !1)
!17 = !DIFile(filename: "callsite_debuginfo.ll", directory: "/")
!31 = distinct !DISubprogram(scope: !10, file: !17, line: 8, type: !11, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !1)
