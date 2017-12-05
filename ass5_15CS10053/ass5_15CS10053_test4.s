	.file	"output.s"

	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$124, %rsp
# 0:res = t000 
	movl	$0, -12(%rbp)
# 1:res = t001 
	movl	$0, -20(%rbp)
# 2:res = t002 
	movl	$0, -28(%rbp)
# 3:res = t003 
	movl	$2, -36(%rbp)
# 4:res = t004 
	movl	$5, -44(%rbp)
# 5:res = t005 
	movl	$0, -52(%rbp)
# 6:res = i arg1 = t005 
	movl	-52(%rbp), %eax
	movl	%eax, -4(%rbp)
# 7:res = t006 arg1 = t005 
	movl	-52(%rbp), %eax
	movl	%eax, -56(%rbp)
# 8:arg1 = i arg2 = sum 
.L3:
	movl	-4(%rbp), %eax
	movl	-24(%rbp), %edx
	cmpl	%edx, %eax
	jl .L1
# 9:
	jmp .L2
# 10:
	jmp .L2
# 11:res = t007 arg1 = i 
.L4:
	movl	-4(%rbp), %eax
	movl	%eax, -60(%rbp)
# 12:res = i arg1 = i 
	movl	-4(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -4(%rbp)
# 13:
	jmp .L3
# 14:res = t008 arg1 = sum arg2 = i 
.L1:
	movl	-24(%rbp), %eax
	movl	-4(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -64(%rbp)
# 15:res = t009 arg1 = t008 arg2 = j 
	movl	-64(%rbp), %eax
	movl	-8(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -68(%rbp)
# 16:res = sum arg1 = t009 
	movl	-68(%rbp), %eax
	movl	%eax, -24(%rbp)
# 17:res = t010 arg1 = t009 
	movl	-68(%rbp), %eax
	movl	%eax, -72(%rbp)
# 18:
	jmp .L4
# 19:res = t011 
.L2:
	movl	$0, -76(%rbp)
# 20:res = sum arg1 = t011 
	movl	-76(%rbp), %eax
	movl	%eax, -24(%rbp)
# 21:res = t012 arg1 = t011 
	movl	-76(%rbp), %eax
	movl	%eax, -80(%rbp)
# 22:res = t013 arg1 = x arg2 = y 
.L7:
	movl	-32(%rbp), %eax
	movl	-40(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -84(%rbp)
# 23:res = x arg1 = t013 
	movl	-84(%rbp), %eax
	movl	%eax, -32(%rbp)
# 24:res = t014 arg1 = t013 
	movl	-84(%rbp), %eax
	movl	%eax, -88(%rbp)
# 25:res = t015 arg1 = sum 
	movl	-24(%rbp), %eax
	movl	%eax, -92(%rbp)
# 26:res = sum arg1 = sum 
	movl	-24(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -24(%rbp)
# 27:res = t016 
	movl	$0, -96(%rbp)
# 28:arg1 = sum arg2 = t016 
	movl	-24(%rbp), %eax
	movl	-96(%rbp), %edx
	cmpl	%edx, %eax
	jg .L5
# 29:
	jmp .L6
# 30:res = t017 
.L5:
	movl	$5, -100(%rbp)
# 31:arg1 = sum arg2 = t017 
	movl	-24(%rbp), %eax
	movl	-100(%rbp), %edx
	cmpl	%edx, %eax
	jl .L7
# 32:
	jmp .L6
# 33:
	jmp .L6
# 34:res = t018 
.L6:
	movl	$1, -108(%rbp)
# 35:res = t019 
.L10:
	movl	$0, -112(%rbp)
# 36:arg1 = whiley arg2 = t019 
	movl	-104(%rbp), %eax
	movl	-112(%rbp), %edx
	cmpl	%edx, %eax
	jg .L8
# 37:
	jmp	.LRT0
# 38:
	jmp	.LRT0
# 39:res = t020 
.L8:
	movl	$1, -116(%rbp)
# 40:res = t021 arg1 = whiley arg2 = t020 
	movl	-104(%rbp), %eax
	movl	-116(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -120(%rbp)
# 41:res = whiley arg1 = t021 
	movl	-120(%rbp), %eax
	movl	%eax, -104(%rbp)
# 42:res = t022 arg1 = t021 
	movl	-120(%rbp), %eax
	movl	%eax, -124(%rbp)
# 43:
	jmp .L10
.LRT0:
	addq	$-124, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
