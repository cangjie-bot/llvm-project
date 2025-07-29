; REQUIRES: x86_64-linux
; RUN: llc -mtriple=x86_64-- --cangjie-pipeline -o - %s | FileCheck %s

define void @main() gc "cangjie" personality i32 (...)* @"__cj_personality_v0$" {
entry:
  ret void
}

define private i32 @"__cj_personality_v0$"(...) {
entry:
  ret i32 0
}

; CHECK:   .section    .cjmetadata.stringpooldict,"aw",@progbits
; CHECK: .Lstr_pool_dict_offsets:
; CHECK:   .long .Lstr_pool_dict.1-.Lstr_pool_dict_offsets
; CHECK: .Lstr_pool_dict.1:
