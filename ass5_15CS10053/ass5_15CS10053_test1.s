	.file	"output.s"

.STR0:	.string "\nHeya!"
	.text
	.globl	fib
	.type	fib, @function
fib:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	movl	%edi, -4(%rbp)
# 0:res = t000 
	movl	$1, -8(%rbp)
# 1:arg1 = x arg2 = t000 
	movl	-4(%rbp), %eax
	movl	-8(%rbp), %edx
	cmpl	%edx, %eax
	jle .L1
# 2:
	jmp .L2
# 3:
	jmp	.LRT0
# 4:res = t001 
.L1:
	movl	$1, -12(%rbp)
# 5:res = t001 
	movl	-12(%rbp), %eax
	jmp	.LRT0
# 6:
	jmp	.LRT0
# 7:res = t002 
.L2:
	movl	$1, -16(%rbp)
# 8:res = t003 arg1 = x arg2 = t002 
	movl	-4(%rbp), %eax
	movl	-16(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -20(%rbp)
# 9:res = t003 
# 10:res = t004 
	pushq %rbp
	movl	-20(%rbp) , %edi
	call	fib
	movl	%eax, -24(%rbp)
	addq $0 , %rsp
# 11:res = t005 
	movl	$2, -28(%rbp)
# 12:res = t006 arg1 = x arg2 = t005 
	movl	-4(%rbp), %eax
	movl	-28(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -32(%rbp)
# 13:res = t006 
# 14:res = t007 
	pushq %rbp
	movl	-32(%rbp) , %edi
	call	fib
	movl	%eax, -36(%rbp)
	addq $0 , %rsp
# 15:res = t008 arg1 = t004 arg2 = t007 
	movl	-24(%rbp), %eax
	movl	-36(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -40(%rbp)
# 16:res = t008 
	movl	-40(%rbp), %eax
	jmp	.LRT0
# 17:
	jmp	.LRT0
.LRT0:
	addq	$-40, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	fib, .-fib
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$36, %rsp
# 18:res = t009 arg1 = n 
.L3:
	leaq	-4(%rbp), %rax
	movq	%rax, -8(%rbp)
# 19:res = t009 
# 20:res = t010 
	pushq %rbp
	movq	-8(%rbp), %rdi
	call	readInt
	movl	%eax, -12(%rbp)
	addq $0 , %rsp
# 21:res = n 
# 22:res = t011 
	pushq %rbp
	movl	-4(%rbp) , %edi
	call	printInt
	movl	%eax, -16(%rbp)
	addq $0 , %rsp
# 23:
	movq	$.STR0,	%rdi
# 24:res = t012 
	pushq %rbp
	call	printStr
	movl	%eax, -20(%rbp)
	addq $0 , %rsp
# 25:res = t013 
	movl	$6, -24(%rbp)
# 26:res = t013 
# 27:res = t014 
	pushq %rbp
	movl	-24(%rbp) , %edi
	call	fib
	movl	%eax, -28(%rbp)
	addq $0 , %rsp
# 28:res = n arg1 = t014 
	movl	-28(%rbp), %eax
	movl	%eax, -4(%rbp)
# 29:res = t015 arg1 = t014 
	movl	-28(%rbp), %eax
	movl	%eax, -32(%rbp)
# 30:res = n 
# 31:res = t016 
	pushq %rbp
	movl	-4(%rbp) , %edi
	call	printInt
	movl	%eax, -36(%rbp)
	addq $0 , %rsp
.LRT1:
	addq	$-36, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
