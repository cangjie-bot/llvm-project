; This test checks asan.module_ctor must have no comdat section.
; This patch is a intermediate fix refering to llvm pull request 67745.
; RUN: opt < %s -passes='asan-module' -cj-asan=true --cangjie-pipeline -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; CHECK-NOT: $asan.module_ctor = comdat any
; CHECK: define internal void @asan.module_ctor() #[[#ATTR:]] {