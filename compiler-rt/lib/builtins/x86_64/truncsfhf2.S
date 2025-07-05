	.text
	.file	"truncsfhf2.c"
	.section	.text.__truncsfhf2,"ax",@progbits
	.globl	__truncsfhf2                    # -- Begin function __truncsfhf2
	.p2align	4, 0x90
	.type	__truncsfhf2,@function
__truncsfhf2:                           # @__truncsfhf2
.L__truncsfhf2$local:
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%fs:40, %rax
	movq	%rax, (%rsp)
	movd	%xmm0, %eax
	movl	%eax, %edx
	andl	$2147483647, %edx               # imm = 0x7FFFFFFF
	leal	-947912704(%rdx), %ecx
	leal	-1199570944(%rdx), %esi
	cmpl	%esi, %ecx
	jae	.LBB0_5
# %bb.1:
	movl	%eax, %edx
	shrl	$13, %edx
	movzwl	%dx, %ecx
	movl	%eax, %esi
	andl	$8191, %esi                     # imm = 0x1FFF
	cmpl	$4097, %esi                     # imm = 0x1001
	jb	.LBB0_3
# %bb.2:
	addl	$-114687, %ecx                  # imm = 0xFFFE4001
	jmp	.LBB0_13
.LBB0_5:
	cmpl	$2139095041, %edx               # imm = 0x7F800001
	jb	.LBB0_7
# %bb.6:
	movl	%eax, %ecx
	shrl	$13, %ecx
	andl	$511, %ecx                      # imm = 0x1FF
	orl	$32256, %ecx                    # imm = 0x7E00
	jmp	.LBB0_13
.LBB0_3:
	addl	$-114688, %ecx                  # imm = 0xFFFE4000
	cmpl	$4096, %esi                     # imm = 0x1000
	jne	.LBB0_13
# %bb.4:
	movzwl	%cx, %ecx
	andl	$1, %edx
	addl	%ecx, %edx
	movl	%edx, %ecx
	jmp	.LBB0_13
.LBB0_7:
	movl	$31744, %ecx                    # imm = 0x7C00
	cmpl	$1199570943, %edx               # imm = 0x477FFFFF
	ja	.LBB0_13
# %bb.8:
	xorl	%ecx, %ecx
	cmpl	$754974720, %edx                # imm = 0x2D000000
	jb	.LBB0_13
# %bb.9:
	shrl	$23, %edx
	movl	%eax, %esi
	andl	$8388607, %esi                  # imm = 0x7FFFFF
	orl	$8388608, %esi                  # imm = 0x800000
	leal	-81(%rdx), %ecx
	movl	%esi, %edi
                                        # kill: def $cl killed $cl killed $ecx
	shll	%cl, %edi
	xorl	%r8d, %r8d
	testl	%edi, %edi
	setne	%r8b
	movb	$113, %cl
	subb	%dl, %cl
	shrl	%cl, %esi
	movl	%esi, %ecx
	shrl	$13, %ecx
	andl	$8191, %esi                     # imm = 0x1FFF
	orl	%r8d, %esi
	cmpl	$4097, %esi                     # imm = 0x1001
	jb	.LBB0_11
# %bb.10:
	incl	%ecx
	jmp	.LBB0_13
.LBB0_11:
	cmpl	$4096, %esi                     # imm = 0x1000
	jne	.LBB0_13
# %bb.12:
	movl	%ecx, %edx
	andl	$1, %edx
	addl	%edx, %ecx
.LBB0_13:
	movq	%fs:40, %rdx
	cmpq	(%rsp), %rdx
	jne	.LBB0_15
# %bb.14:
	shrl	$16, %eax
	andl	$32768, %eax                    # imm = 0x8000
	orl	%eax, %ecx
	pinsrw	$0, %ecx, %xmm0
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.LBB0_15:
	.cfi_def_cfa_offset 16
	callq	__stack_chk_fail@PLT
.Lfunc_end0:
	.size	__truncsfhf2, .Lfunc_end0-__truncsfhf2
	.cfi_endproc
                                        # -- End function
	.section	.text.__gnu_f2h_ieee,"ax",@progbits
	.globl	__gnu_f2h_ieee                  # -- Begin function __gnu_f2h_ieee
	.p2align	4, 0x90
	.type	__gnu_f2h_ieee,@function
__gnu_f2h_ieee:                         # @__gnu_f2h_ieee
.L__gnu_f2h_ieee$local:
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%fs:40, %rax
	movq	%rax, (%rsp)
	callq	.L__truncsfhf2$local
	movq	%fs:40, %rax
	cmpq	(%rsp), %rax
	jne	.LBB1_2
# %bb.1:
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.LBB1_2:
	.cfi_def_cfa_offset 16
	callq	__stack_chk_fail@PLT
.Lfunc_end1:
	.size	__gnu_f2h_ieee, .Lfunc_end1-__gnu_f2h_ieee
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 15.0.4"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __stack_chk_fail
