; Warn.
; RUN: llc -mtriple=x86_64 < %s 2>&1 | FileCheck %s

; CHECK: warning: stack frame size (4194232) exceeds limit (1048576) in function 'main1'

define i32 @main1() gc "cangjie"  {
mainEntry:

  %array = alloca [1048590 x i32], align 4

  %gep = getelementptr [1048590 x i32], [1048590 x i32]* %array, i32 0, i32 0

  store i32 1, i32* %gep, align 4

  %gep1 = getelementptr [1048590 x i32], [1048590 x i32]* %array, i32 0, i32 1

  store i32 2, i32* %gep1, align 4

  %gep2 = getelementptr [1048590 x i32], [1048590 x i32]* %array, i32 0, i32 2

  store i32 3, i32* %gep2, align 4

  %arr_index_pointer = getelementptr [1048590 x i32], [1048590 x i32]* %array, i32 0, i32 1

  %a = load i32, i32* %arr_index_pointer, align 4

  ret i32 %a
}

; CHECK-NOT: warning: stack frame size

; No warn.
define i32 @main2() gc "cangjie"  {
mainEntry:

  %array = alloca [100 x i32], align 4

  %gep = getelementptr [100 x i32], [100 x i32]* %array, i32 0, i32 0

  store i32 1, i32* %gep, align 4

  %gep1 = getelementptr [100 x i32], [100 x i32]* %array, i32 0, i32 1

  store i32 2, i32* %gep1, align 4

  %gep2 = getelementptr [100 x i32], [100 x i32]* %array, i32 0, i32 2

  store i32 3, i32* %gep2, align 4

  %arr_index_pointer = getelementptr [100 x i32], [100 x i32]* %array, i32 0, i32 1

  %a = load i32, i32* %arr_index_pointer, align 4

  ret i32 %a
}
