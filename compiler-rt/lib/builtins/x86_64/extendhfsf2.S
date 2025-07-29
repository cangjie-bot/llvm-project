	.text
	.file	"extendhfsf2.c"
	.section	.text.__extendhfsf2,"ax",@progbits
	.globl	__extendhfsf2                   # -- Begin function __extendhfsf2
	.p2align	4, 0x90
	.type	__extendhfsf2,@function
__extendhfsf2:                          # @__extendhfsf2
.L__extendhfsf2$local:
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%fs:40, %rax
	movq	%rax, (%rsp)
	pextrw	$0, %xmm0, %eax
	movl	%eax, %edx
	andl	$32767, %edx                    # imm = 0x7FFF
	leal	-1024(%rdx), %ecx
	movzwl	%cx, %ecx
	cmpl	$30719, %ecx                    # imm = 0x77FF
	ja	.LBB0_2
# %bb.1:
	shll	$13, %edx
	addl	$939524096, %edx                # imm = 0x38000000
	movq	%fs:40, %rcx
	cmpq	(%rsp), %rcx
	je	.LBB0_8
	jmp	.LBB0_9
.LBB0_2:
	cmpl	$31744, %edx                    # imm = 0x7C00
	jb	.LBB0_4
# %bb.3:
	shll	$13, %edx
	orl	$2139095040, %edx               # imm = 0x7F800000
	movq	%fs:40, %rcx
	cmpq	(%rsp), %rcx
	je	.LBB0_8
	jmp	.LBB0_9
.LBB0_4:
	testl	%edx, %edx
	je	.LBB0_5
# %bb.6:
	bsrl	%edx, %esi
	xorl	$31, %esi
	leal	-8(%rsi), %ecx
                                        # kill: def $cl killed $cl killed $ecx
	shll	%cl, %edx
	xorl	$8388608, %edx                  # imm = 0x800000
	shll	$23, %esi
	movl	$1124073472, %ecx               # imm = 0x43000000
	subl	%esi, %ecx
	orl	%edx, %ecx
	movl	%ecx, %edx
	movq	%fs:40, %rcx
	cmpq	(%rsp), %rcx
	jne	.LBB0_9
.LBB0_8:
	andl	$32768, %eax                    # imm = 0x8000
	shll	$16, %eax
	orl	%eax, %edx
	movd	%edx, %xmm0
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.LBB0_5:
	.cfi_def_cfa_offset 16
	xorl	%edx, %edx
	movq	%fs:40, %rcx
	cmpq	(%rsp), %rcx
	je	.LBB0_8
.LBB0_9:
	callq	__stack_chk_fail@PLT
.Lfunc_end0:
	.size	__extendhfsf2, .Lfunc_end0-__extendhfsf2
	.cfi_endproc
                                        # -- End function
	.section	.text.__gnu_h2f_ieee,"ax",@progbits
	.globl	__gnu_h2f_ieee                  # -- Begin function __gnu_h2f_ieee
	.p2align	4, 0x90
	.type	__gnu_h2f_ieee,@function
__gnu_h2f_ieee:                         # @__gnu_h2f_ieee
.L__gnu_h2f_ieee$local:
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%fs:40, %rax
	movq	%rax, (%rsp)
	callq	.L__extendhfsf2$local
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
	.size	__gnu_h2f_ieee, .Lfunc_end1-__gnu_h2f_ieee
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 15.0.4"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __stack_chk_fail
