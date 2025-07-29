	.text
	.file	"truncdfhf2.c"
	.section	.text.__truncdfhf2,"ax",@progbits
	.globl	__truncdfhf2                    # -- Begin function __truncdfhf2
	.p2align	4, 0x90
	.type	__truncdfhf2,@function
__truncdfhf2:                           # @__truncdfhf2
.L__truncdfhf2$local:
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%fs:40, %rax
	movq	%rax, (%rsp)
	movq	%xmm0, %rax
	movabsq	$9223372036854775807, %rdx      # imm = 0x7FFFFFFFFFFFFFFF
	andq	%rax, %rdx
	movabsq	$-4544132024016830464, %rcx     # imm = 0xC0F0000000000000
	addq	%rdx, %rcx
	movabsq	$-4679240012837945344, %rsi     # imm = 0xBF10000000000000
	addq	%rdx, %rsi
	cmpq	%rsi, %rcx
	jae	.LBB0_5
# %bb.1:
	movabsq	$2199023255552, %rsi            # imm = 0x20000000000
	movq	%rax, %rdx
	shrq	$42, %rdx
	movl	%edx, %ecx
	addl	$16384, %ecx                    # imm = 0x4000
	movabsq	$4398046511103, %rdi            # imm = 0x3FFFFFFFFFF
	andq	%rax, %rdi
	cmpq	%rsi, %rdi
	jbe	.LBB0_3
# %bb.2:
	leal	16385(%rdx), %ecx
	jmp	.LBB0_14
.LBB0_5:
	movabsq	$9218868437227405313, %rcx      # imm = 0x7FF0000000000001
	cmpq	%rcx, %rdx
	jb	.LBB0_7
# %bb.6:
	movq	%rax, %rcx
	shrq	$42, %rcx
	andl	$511, %ecx                      # imm = 0x1FF
	orl	$32256, %ecx                    # imm = 0x7E00
	jmp	.LBB0_14
.LBB0_3:
	jne	.LBB0_14
# %bb.4:
	andl	$1, %edx
	addl	%edx, %ecx
	jmp	.LBB0_14
.LBB0_7:
	shrq	$52, %rdx
	movw	$31744, %cx                     # imm = 0x7C00
	cmpl	$1038, %edx                     # imm = 0x40E
	ja	.LBB0_14
# %bb.8:
	cmpl	$957, %edx                      # imm = 0x3BD
	jae	.LBB0_10
# %bb.9:
	xorl	%ecx, %ecx
	jmp	.LBB0_14
.LBB0_10:
	movabsq	$4503599627370495, %rcx         # imm = 0xFFFFFFFFFFFFF
	movq	%rax, %rsi
	andq	%rcx, %rsi
	addq	%rcx, %rsi
	incq	%rsi
	leal	79(%rdx), %ecx
	movq	%rsi, %rdi
                                        # kill: def $cl killed $cl killed $ecx
	shlq	%cl, %rdi
	xorl	%r8d, %r8d
	testq	%rdi, %rdi
	setne	%r8b
	movb	$-15, %cl
	subb	%dl, %cl
	shrq	%cl, %rsi
	movabsq	$2199023255552, %rdx            # imm = 0x20000000000
	movabsq	$4398046511103, %rdi            # imm = 0x3FFFFFFFFFF
	andq	%rsi, %rdi
	movq	%rsi, %rcx
	shrq	$42, %rcx
	orq	%r8, %rdi
	cmpq	%rdx, %rdi
	jbe	.LBB0_12
# %bb.11:
	movzwl	%cx, %ecx
	incl	%ecx
	jmp	.LBB0_14
.LBB0_12:
	jne	.LBB0_14
# %bb.13:
	movzwl	%cx, %edx
	movl	%edx, %ecx
	andl	$1, %ecx
	addl	%edx, %ecx
.LBB0_14:
	movq	%fs:40, %rdx
	cmpq	(%rsp), %rdx
	jne	.LBB0_16
# %bb.15:
	shrq	$48, %rax
	andl	$32768, %eax                    # imm = 0x8000
	orl	%eax, %ecx
	pinsrw	$0, %ecx, %xmm0
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.LBB0_16:
	.cfi_def_cfa_offset 16
	callq	__stack_chk_fail@PLT
.Lfunc_end0:
	.size	__truncdfhf2, .Lfunc_end0-__truncdfhf2
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 15.0.4"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __stack_chk_fail
