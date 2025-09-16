; RUN: opt < %s -passes=cj-runtime-lowering -S | FileCheck %s
%TypeInfo = type { i8*, i8, i8, i16, i32, i8*, i32, i8, i8, i32*, i8*, i8*, i8*, i8*, i8*, i8* }

declare i8 addrspace(1)* @llvm.cj.malloc.object(i8*, i32)

; Function Attrs: nounwind
declare i8* @llvm.cj.get.exception.wrapper() #0

; Function Attrs: nounwind
declare i8 addrspace(1)* @llvm.cj.post.throw.exception(i8*) #0

declare void @llvm.cj.throw.exception(i8 addrspace(1)*)

; Transfer the original function's attributes.

; CHECK:    %3 = load i32, i32* %2, align 4
; CHECK:    %4 = add i32 %3, 15
; CHECK     %5 = and i32 %4, -8
; CHECK:    declare noalias i8 addrspace(1)* @CJ_MCC_NewObject(i8*, i32) #2
; CHECK:    declare i8* @CJ_MCC_GetExceptionWrapper() #3
; CHECK:    declare i8 addrspace(1)* @CJ_MCC_PostThrowException(i8*) #3
; CHECK:    declare void @CJ_MCC_ThrowException(i8 addrspace(1)*) #1
; CHECK:    attributes #1 = { "cj-runtime" "gc-leaf-function" }
; CHECK:    attributes #2 = { argmemonly "cj-heapmalloc" "cj-runtime" }
; CHECK:    attributes #3 = { nounwind "cj-runtime" "gc-leaf-function" }
;

define void @lower_new_finalier(i8* %ti) {
  %obj = call noalias i8 addrspace(1)* @llvm.cj.malloc.object(i8* %ti, i32 32)
  %e = call i8* @llvm.cj.get.exception.wrapper()
  %e_obj = call i8 addrspace(1)* @llvm.cj.post.throw.exception(i8* %e)
  call void @llvm.cj.throw.exception(i8 addrspace(1)* %e_obj)
  ret void
}

attributes #0 = { nounwind }
