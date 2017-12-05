	.file	"output.s"

	.text
	.globl	sum
	.type	sum, @function
sum:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
# 25:res = t010 arg1 = a arg2 = b 
	movl	-8(%rbp), %eax
	movl	-4(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -16(%rbp)
# 26:res = ans 
	movl	-12(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-16, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	sum, .-sum
	.globl	mod
	.type	mod, @function
mod:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
# 27:res = t011 arg1 = a arg2 = b 
	movl	-8(%rbp), %eax
	cltd
	idivl	-4(%rbp), %eax
	movl	%edx, -16(%rbp)
# 28:res = ans 
	movl	-12(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-16, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	mod, .-mod
	.globl	mod_2
	.type	mod_2, @function
mod_2:
.LFB2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$36, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
# 43:arg1 = a arg2 = b 
	movl	-8(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jg .L7
# 44:
	jmp .L8
# 45:
	jmp .L9
# 46:res = a 
.L7:
# 47:res = b 
# 48:res = t018 
	pushq %rbp
	movl	-4(%rbp) , %edi
	movl	-8(%rbp) , %esi
	call	divide
	movl	%eax, -16(%rbp)
	addq $0 , %rsp
# 49:res = t019 arg1 = a arg2 = t018 
	movl	-8(%rbp), %eax
	movl	-16(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -20(%rbp)
# 50:res = ans arg1 = t019 
	movl	-20(%rbp), %eax
	movl	%eax, -12(%rbp)
# 51:res = t020 arg1 = t019 
	movl	-20(%rbp), %eax
	movl	%eax, -24(%rbp)
# 52:
	jmp .L9
# 53:res = a 
.L8:
# 54:res = b 
# 55:res = t021 
	pushq %rbp
	movl	-4(%rbp) , %edi
	movl	-8(%rbp) , %esi
	call	divide
	movl	%eax, -28(%rbp)
	addq $0 , %rsp
# 56:res = t022 arg1 = b arg2 = t021 
	movl	-4(%rbp), %eax
	movl	-28(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -32(%rbp)
# 57:res = ans arg1 = t022 
	movl	-32(%rbp), %eax
	movl	%eax, -12(%rbp)
# 58:res = t023 arg1 = t022 
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)
# 59:
	jmp .L9
# 60:res = ans 
.L9:
	movl	-12(%rbp), %eax
	jmp	.LRT2
.LRT2:
	addq	$-36, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE2:
	.size	mod_2, .-mod_2
	.globl	divide
	.type	divide, @function
divide:
.LFB3:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$36, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
# 29:res = t012 
	movl	$0, -16(%rbp)
# 30:arg1 = b arg2 = t012 
	movl	-4(%rbp), %eax
	movl	-16(%rbp), %edx
	cmpl	%edx, %eax
	jne .L4
# 31:
	jmp .L5
# 32:
	jmp .L6
# 33:res = t013 arg1 = a arg2 = b 
.L4:
	movl	-8(%rbp), %eax
	cltd
	idivl	-4(%rbp), %eax
	movl	%eax, -20(%rbp)
# 34:res = ans arg1 = t013 
	movl	-20(%rbp), %eax
	movl	%eax, -12(%rbp)
# 35:res = t014 arg1 = t013 
	movl	-20(%rbp), %eax
	movl	%eax, -24(%rbp)
# 36:
	jmp .L6
# 37:res = t015 
.L5:
	movl	$1, -28(%rbp)
# 38:res = t016 arg1 = t015 
	movl	-28(%rbp), %eax
	negl	%eax
	movl	%eax, -32(%rbp)
# 39:res = ans arg1 = t016 
	movl	-32(%rbp), %eax
	movl	%eax, -12(%rbp)
# 40:res = t017 arg1 = t016 
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)
# 41:
	jmp .L6
# 42:res = ans 
.L6:
	movl	-12(%rbp), %eax
	jmp	.LRT3
.LRT3:
	addq	$-36, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE3:
	.size	divide, .-divide
	.globl	main
	.type	main, @function
main:
.LFB4:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$60, %rsp
# 0:res = t000 
	movl	$2, -8(%rbp)
# 1:res = t001 
	movl	$5, -16(%rbp)
# 2:res = x 
# 3:res = y 
# 4:res = t002 
	pushq %rbp
	movl	-12(%rbp) , %edi
	movl	-4(%rbp) , %esi
	call	sum
	movl	%eax, -24(%rbp)
	addq $0 , %rsp
# 5:res = x 
# 6:res = y 
# 7:res = t003 
	pushq %rbp
	movl	-12(%rbp) , %edi
	movl	-4(%rbp) , %esi
	call	mod
	movl	%eax, -32(%rbp)
	addq $0 , %rsp
# 8:res = x 
# 9:res = y 
# 10:res = t004 
	pushq %rbp
	movl	-12(%rbp) , %edi
	movl	-4(%rbp) , %esi
	call	mod_2
	movl	%eax, -40(%rbp)
	addq $0 , %rsp
# 11:arg1 = md arg2 = md_2 
	movl	-28(%rbp), %eax
	movl	-36(%rbp), %edx
	cmpl	%edx, %eax
	je .L1
# 12:
	jmp .L2
# 13:
	jmp .L3
# 14:res = t005 
.L1:
	movl	$0, -44(%rbp)
# 15:res = y arg1 = t005 
	movl	-44(%rbp), %eax
	movl	%eax, -12(%rbp)
# 16:res = t006 arg1 = t005 
	movl	-44(%rbp), %eax
	movl	%eax, -48(%rbp)
# 17:
	jmp .L3
# 18:res = t007 
.L2:
	movl	$1, -52(%rbp)
# 19:res = y arg1 = t007 
	movl	-52(%rbp), %eax
	movl	%eax, -12(%rbp)
# 20:res = t008 arg1 = t007 
	movl	-52(%rbp), %eax
	movl	%eax, -56(%rbp)
# 21:
	jmp .L3
# 22:res = x 
.L3:
# 23:res = y 
# 24:res = t009 
	pushq %rbp
	movl	-12(%rbp) , %edi
	movl	-4(%rbp) , %esi
	call	mod_2
	movl	%eax, -60(%rbp)
	addq $0 , %rsp
.LRT4:
	addq	$-60, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE4:
	.size	main, .-main
