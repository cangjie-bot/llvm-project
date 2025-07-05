; RUN: llc -O0 --cangjie-pipeline -mtriple x86_64-pc-linux-gnu  < %s  | FileCheck %s

%record = type { i64, i8 addrspace(1)* }

declare void @cj_stack_grow()

declare void @test(i8 addrspace(1)*, %record addrspace(1)*) #0 gc "cangjie"

define i64 @foo(i8 addrspace(1)* %a) #0 gc "cangjie" {
; CHECK:       subq    $24, %rsp
; CHECK-NEXT:  leaq    -24(%rbp), %rdi
; CHECK-NEXT:  xorl    %esi, %esi
; CHECK-NEXT:  movl    $16, %edx
; CHECK-NEXT:  callq   memset@PLT
; CHECK-NEXT:  # %bb.1:     # %body
; CHECK-NEXT:  callq   cj_stack_grow@PLT
; CHECK-LABEL: .Ltmp1:
; CHECK-NEXT:  xorl    %eax, %eax
; CHECK-NEXT:  movl    %eax, %edi
; CHECK-NEXT:  leaq    -24(%rbp), %rsi
; CHECK-NEXT:  callq   test@PLT

entry:
  %r = alloca %record, align 8
  %r.cast = bitcast %record* %r to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 %r.cast, i8 0, i64 16, i1 false)
  br label %body

body:                                             ; preds = %entry
  %token = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void ()* @cj_stack_grow, i32 0, i32 0) [ "struct-live"(%record* %r) ]
  %var = addrspacecast %record* %r to %record addrspace(1)*
  %token1 = call token (...) @llvm.cj.gc.statepoint(i64 0, i32 0, void (i8 addrspace(1)*, %record addrspace(1)*)* @test, i32 2, i32 0, i8 addrspace(1)* null, %record addrspace(1)* %var) [ "struct-live"(%record* %r) ]
  ret i64 0
}

; Function Attrs: argmemonly nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

declare token @llvm.cj.gc.statepoint(...)

attributes #0 = { "hasRcdParam" }
attributes #1 = { argmemonly nocallback nofree nounwind willreturn writeonly }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"HasRewrittenStatepoint", i32 1}
