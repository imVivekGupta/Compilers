	.file	"ass5_15CS10053_test5.mm"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$120, %rsp
	movb	$97, -231(%rbp)
	movb	$98, -230(%rbp)
	movb	$99, -229(%rbp)
	movabsq	$4607182418800017408, %rax
	movq	%rax, -192(%rbp)
	movabsq	$4611686018427387904, %rax
	movq	%rax, -184(%rbp)
	movabsq	$4613937818241073152, %rax
	movq	%rax, -176(%rbp)
	movabsq	$4616189618054758400, %rax
	movq	%rax, -168(%rbp)
	movabsq	$4617315517961601024, %rax
	movq	%rax, -160(%rbp)
	movabsq	$4618441417868443648, %rax
	movq	%rax, -152(%rbp)
	movabsq	$4618441417868443648, %rax
	movq	%rax, -144(%rbp)
	movabsq	$4618328827877759386, %rax
	movq	%rax, -136(%rbp)
	movabsq	$4615964438073389875, %rax
	movq	%rax, -128(%rbp)
	movabsq	$4613937818241073152, %rax
	movq	%rax, -120(%rbp)
	movabsq	$4611686018427387904, %rax
	movq	%rax, -112(%rbp)
	movabsq	$4607182418800017408, %rax
	movq	%rax, -104(%rbp)
	movl	$0, -224(%rbp)
	jmp	.L2
.L5:
	movl	$0, -220(%rbp)
	jmp	.L3
.L4:
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	-192(%rbp,%rax,8), %xmm1
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	-144(%rbp,%rax,8), %xmm0
	addsd	%xmm1, %xmm0
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	%xmm0, -96(%rbp,%rax,8)
	addl	$1, -220(%rbp)
.L3:
	cmpl	$2, -220(%rbp)
	jle	.L4
	addl	$1, -224(%rbp)
.L2:
	cmpl	$1, -224(%rbp)
	jle	.L5
	movl	$0, -224(%rbp)
	jmp	.L6
.L9:
	movl	$0, -220(%rbp)
	jmp	.L7
.L8:
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	-192(%rbp,%rax,8), %xmm0
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	-144(%rbp,%rax,8), %xmm1
	subsd	%xmm1, %xmm0
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	%xmm0, -96(%rbp,%rax,8)
	addl	$1, -220(%rbp)
.L7:
	cmpl	$2, -220(%rbp)
	jle	.L8
	addl	$1, -224(%rbp)
.L6:
	cmpl	$1, -224(%rbp)
	jle	.L9
	movl	$0, -224(%rbp)
	jmp	.L10
.L13:
	movl	$0, -220(%rbp)
	jmp	.L11
.L12:
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	-192(%rbp,%rax,8), %xmm1
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	-144(%rbp,%rax,8), %xmm0
	mulsd	%xmm1, %xmm0
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movsd	%xmm0, -96(%rbp,%rax,8)
	addl	$1, -220(%rbp)
.L11:
	cmpl	$2, -220(%rbp)
	jle	.L12
	addl	$1, -224(%rbp)
.L10:
	cmpl	$1, -224(%rbp)
	jle	.L13
	movl	$0, -224(%rbp)
	jmp	.L14
.L17:
	movl	$0, -220(%rbp)
	jmp	.L15
.L16:
	movl	-220(%rbp), %eax
	movslq	%eax, %rcx
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	movq	-192(%rbp,%rax,8), %rax
	movl	-224(%rbp), %edx
	movslq	%edx, %rdx
	movl	-220(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	%rcx, %rcx
	addq	%rcx, %rdx
	movq	%rax, -48(%rbp,%rdx,8)
	addl	$1, -220(%rbp)
.L15:
	cmpl	$2, -220(%rbp)
	jle	.L16
	addl	$1, -224(%rbp)
.L14:
	cmpl	$1, -224(%rbp)
	jle	.L17
	leaq	-231(%rbp), %rax
	movq	%rax, -208(%rbp)
	movl	$9, -216(%rbp)
	movl	-216(%rbp), %eax
	addl	$10, %eax
	movl	%eax, -212(%rbp)
	movl	$50, -228(%rbp)
	leaq	-228(%rbp), %rax
	movq	%rax, -200(%rbp)
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	mult
	.type	mult, @function
mult:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, -24(%rbp)
	movl	%edi, -28(%rbp)
	cvtsi2sd	-28(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0
	movsd	%xmm0, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	mult, .-mult
	.globl	garb
	.type	garb, @function
garb:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -36(%rbp)
	movsd	%xmm0, -48(%rbp)
	movl	%esi, %eax
	movb	%al, -40(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	leaq	-40(%rbp), %rax
	movq	%rax, -8(%rbp)
	cvtsi2sd	-36(%rbp), %xmm0
	addsd	-48(%rbp), %xmm0
	cvttsd2si	%xmm0, %eax
	movl	%eax, -20(%rbp)
	movzbl	-40(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	garb, .-garb
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
