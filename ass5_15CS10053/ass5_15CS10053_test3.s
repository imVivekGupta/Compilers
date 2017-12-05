	.file	"output.s"

	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$86, %rsp
# 0:res = t000 
	movl	$2, -8(%rbp)
# 1:res = t001 
	movl	$3, -16(%rbp)
# 2:res = b arg1 = t001 
	movl	-16(%rbp), %eax
	movl	%eax, -12(%rbp)
# 3:res = t002 arg1 = t001 
	movl	-16(%rbp), %eax
	movl	%eax, -20(%rbp)
# 4:res = b 
# 5:res = t003 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printInt
	movl	%eax, -24(%rbp)
	addq $0 , %rsp
# 6:res = t004 arg1 = a 
	leaq	-4(%rbp), %rax
	movq	%rax, -28(%rbp)
# 7:res = t004 
# 8:res = t005 
	pushq %rbp
	movq	-28(%rbp), %rdi
	call	readInt
	movl	%eax, -32(%rbp)
	addq $0 , %rsp
# 9:res = t006 
	movl	$105, -34(%rbp)
# 10:res = t007 
	movl	$107, -36(%rbp)
# 11:res = t008 
	movl	$48, -38(%rbp)
# 12:arg1 = b arg2 = a 
	movl	-12(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jg .L1
# 13:
	jmp .L2
# 14:
	jmp	.LRT0
# 15:arg1 = c arg2 = d 
.L1:
	movzbl	-33(%rbp), %eax
	cmpb	-35(%rbp), %al
	jg .L4
# 16:
	jmp .L5
# 17:
	jmp .L6
# 18:res = t009 arg1 = sum arg2 = c 
.L4:
	movzbl	-37(%rbp), %eax
	movzbl	-33(%rbp), %edx
	addl	%edx, %eax
	movb	%al, -39(%rbp)
# 19:res = sum arg1 = t009 
	movzbl	-39(%rbp), %eax
	movb	%al, -37(%rbp)
# 20:res = t010 arg1 = t009 
	movzbl	-39(%rbp), %eax
	movb	%al, -40(%rbp)
# 21:res = t011 arg1 = sum 
# 22:res = t012 arg1 = t011 arg2 = b 
	movl	-44(%rbp), %eax
	movl	-12(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -48(%rbp)
# 23:res = t013 arg1 = t012 
# 24:res = sum arg1 = t013 
	movzbl	-49(%rbp), %eax
	movb	%al, -37(%rbp)
# 25:res = t014 arg1 = t013 
	movzbl	-49(%rbp), %eax
	movb	%al, -50(%rbp)
# 26:
	jmp	.LRT0
# 27:res = t015 arg1 = sum arg2 = d 
.L5:
	movzbl	-37(%rbp), %eax
	movzbl	-35(%rbp), %edx
	addl	%edx, %eax
	movb	%al, -51(%rbp)
# 28:res = sum arg1 = t015 
	movzbl	-51(%rbp), %eax
	movb	%al, -37(%rbp)
# 29:res = t016 arg1 = t015 
	movzbl	-51(%rbp), %eax
	movb	%al, -52(%rbp)
# 30:res = t017 arg1 = sum 
# 31:res = t018 arg1 = t017 arg2 = b 
	movl	-56(%rbp), %eax
	movl	-12(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -60(%rbp)
# 32:res = t019 arg1 = t018 
# 33:res = sum arg1 = t019 
	movzbl	-61(%rbp), %eax
	movb	%al, -37(%rbp)
# 34:res = t020 arg1 = t019 
	movzbl	-61(%rbp), %eax
	movb	%al, -62(%rbp)
# 35:
	jmp	.LRT0
# 36:
.L6:
	jmp	.LRT0
# 37:arg1 = c arg2 = d 
.L2:
	movzbl	-33(%rbp), %eax
	cmpb	-35(%rbp), %al
	jg .L7
# 38:
	jmp .L8
# 39:
	jmp .L9
# 40:res = t021 arg1 = sum arg2 = c 
.L7:
	movzbl	-37(%rbp), %eax
	movzbl	-33(%rbp), %edx
	addl	%edx, %eax
	movb	%al, -63(%rbp)
# 41:res = sum arg1 = t021 
	movzbl	-63(%rbp), %eax
	movb	%al, -37(%rbp)
# 42:res = t022 arg1 = t021 
	movzbl	-63(%rbp), %eax
	movb	%al, -64(%rbp)
# 43:res = t023 arg1 = sum 
# 44:res = t024 arg1 = t023 arg2 = a 
	movl	-68(%rbp), %eax
	movl	-4(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -72(%rbp)
# 45:res = t025 arg1 = t024 
# 46:res = sum arg1 = t025 
	movzbl	-73(%rbp), %eax
	movb	%al, -37(%rbp)
# 47:res = t026 arg1 = t025 
	movzbl	-73(%rbp), %eax
	movb	%al, -74(%rbp)
# 48:
	jmp	.LRT0
# 49:res = t027 arg1 = sum arg2 = d 
.L8:
	movzbl	-37(%rbp), %eax
	movzbl	-35(%rbp), %edx
	addl	%edx, %eax
	movb	%al, -75(%rbp)
# 50:res = sum arg1 = t027 
	movzbl	-75(%rbp), %eax
	movb	%al, -37(%rbp)
# 51:res = t028 arg1 = t027 
	movzbl	-75(%rbp), %eax
	movb	%al, -76(%rbp)
# 52:res = t029 arg1 = sum 
# 53:res = t030 arg1 = t029 arg2 = a 
	movl	-80(%rbp), %eax
	movl	-4(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -84(%rbp)
# 54:res = t031 arg1 = t030 
# 55:res = sum arg1 = t031 
	movzbl	-85(%rbp), %eax
	movb	%al, -37(%rbp)
# 56:res = t032 arg1 = t031 
	movzbl	-85(%rbp), %eax
	movb	%al, -86(%rbp)
# 57:
	jmp	.LRT0
# 58:
.L9:
	jmp	.LRT0
.LRT0:
	addq	$-86, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
