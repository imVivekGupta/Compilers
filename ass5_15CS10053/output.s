	.file	"output.s"

	.text
	.globl	mult
	.type	mult, @function
mult:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$44, %rsp
	movl	%edi, -4(%rbp)
	movsd	%xmm1, -12(%rbp)
# 52:res = t048 arg1 = b 
# 53:res = t049 arg1 = a arg2 = t048 
	movl	-12(%rbp), %eax
	imull	-28(%rbp), %eax
	movl	%eax, -36(%rbp)
# 54:res = ans arg1 = t049 
	movq	-36(%rbp), %rax
	movq	%rax, -20(%rbp)
# 55:res = t050 arg1 = t049 
	movq	-36(%rbp), %rax
	movq	%rax, -44(%rbp)
# 56:res = ans 
	movl	-20(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-44, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	mult, .-mult
	.globl	garb
	.type	garb, @function
garb:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$49, %rsp
	movb	%dil, -1(%rbp)
	movsd	%xmm1, -9(%rbp)
	movl	%edx, -13(%rbp)
# 57:res = t051 arg1 = c 
	leaq	-1(%rbp), %rax
	movq	%rax, -29(%rbp)
# 58:res = t052 arg1 = a 
# 59:res = t053 arg1 = t052 arg2 = b 
	movsd	-41(%rbp), %eax
	movsd	-9(%rbp), %edx
	addsd	%edx, %eax
	movsd	%eax, -49(%rbp)
# 60:res = c 
	movzbl	-1(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-49, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	garb, .-garb
	.globl	main
	.type	main, @function
main:
.LFB2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$798, %rsp
# 0:res = t000 
	movl	$97, -2(%rbp)
# 1:res = t001 
	movl	$98, -4(%rbp)
# 2:res = t002 
	movl	$99, -6(%rbp)
# 3:res = t003 
	movl	$2, -58(%rbp)
# 4:res = t004 
	movl	$3, -62(%rbp)
# 5:res = t005 
	movl	$1.000000, -70(%rbp)
# 6:res = t006 
	movl	$2.000000, -78(%rbp)
# 7:res = t007 
	movl	$3.000000, -86(%rbp)
# 8:res = t008 
	movl	$4.000000, -94(%rbp)
# 9:res = t009 
	movl	$5.000000, -102(%rbp)
# 10:res = t010 
	movl	$6.000000, -110(%rbp)
# 11:res = t011 
	movl	$2, -162(%rbp)
# 12:res = t012 
	movl	$3, -166(%rbp)
# 13:res = t013 
	movl	$6.000000, -174(%rbp)
# 14:res = t014 
	movl	$5.900000, -182(%rbp)
# 15:res = t015 
	movl	$3.900000, -190(%rbp)
# 16:res = t016 
	movl	$3.000000, -198(%rbp)
# 17:res = t017 
	movl	$2.000000, -206(%rbp)
# 18:res = t018 
	movl	$1.000000, -214(%rbp)
# 19:res = t019 
	movl	$2, -266(%rbp)
# 20:res = t020 
	movl	$3, -270(%rbp)
# 21:res = t021 
	movl	$3, -322(%rbp)
# 22:res = t022 
	movl	$2, -326(%rbp)
# 23:res = t023 
	movl	$8, -330(%rbp)
# 24:res = t024 
	movl	$8, -334(%rbp)
# 25:res = t025 
	movl	$8, -338(%rbp)
# 26:res = t026 arg1 = t024 arg2 = t025 
	movl	-334(%rbp), %eax
	movl	-338(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -386(%rbp)
# 27:res = C arg1 = t023 arg2 = t026 
	leaq	-262(%rbp), %rdx
	movslq	-330(%rbp), %rax
	addq	%rax, %rdx
	movl	-386(%rbp), %eax
	movl	%eax, (%rdx)
# 28:res = t027 arg1 = t026 
	movq	-386(%rbp), %rax
	movq	%rax, -434(%rbp)
# 29:res = t028 
	movl	$8, -438(%rbp)
# 30:res = t029 
	movl	$8, -442(%rbp)
# 31:res = t030 
	movl	$8, -446(%rbp)
# 32:res = t031 arg1 = t029 arg2 = t030 
	movl	-442(%rbp), %eax
	movl	-446(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -494(%rbp)
# 33:res = C arg1 = t028 arg2 = t031 
	leaq	-262(%rbp), %rdx
	movslq	-438(%rbp), %rax
	addq	%rax, %rdx
	movl	-494(%rbp), %eax
	movl	%eax, (%rdx)
# 34:res = t032 arg1 = t031 
	movq	-494(%rbp), %rax
	movq	%rax, -542(%rbp)
# 35:res = t033 
	movl	$8, -546(%rbp)
# 36:res = t034 
	movl	$8, -550(%rbp)
# 37:res = t035 
	movl	$8, -554(%rbp)
# 38:res = t036 arg1 = t034 arg2 = t035 
	movl	-550(%rbp), %eax
	imull	-554(%rbp), %eax
	movl	%eax, -602(%rbp)
# 39:res = C arg1 = t033 arg2 = t036 
	leaq	-262(%rbp), %rdx
	movslq	-546(%rbp), %rax
	addq	%rax, %rdx
	movl	-602(%rbp), %eax
	movl	%eax, (%rdx)
# 40:res = t037 arg1 = t036 
	movq	-602(%rbp), %rax
	movq	%rax, -650(%rbp)
# 41:res = t038 
	movl	$8, -654(%rbp)
# 42:res = t039 
	movl	$8, -658(%rbp)
# 43:res = t040 arg1 = t039 
# 44:res = A_ arg1 = t038 arg2 = t040 
	leaq	-318(%rbp), %rdx
	movslq	-654(%rbp), %rax
	addq	%rax, %rdx
	movl	-706(%rbp), %eax
	movl	%eax, (%rdx)
# 45:res = t041 arg1 = t040 
	movq	-706(%rbp), %rax
	movq	%rax, -754(%rbp)
# 46:res = t042 arg1 = a 
	leaq	-1(%rbp), %rax
	movq	%rax, -762(%rbp)
# 47:res = t043 
	movl	$9, -770(%rbp)
# 48:res = t044 
	movl	$10, -778(%rbp)
# 49:res = t045 arg1 = k arg2 = t044 
	movl	-766(%rbp), %eax
	movl	-778(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -782(%rbp)
# 50:res = t046 
	movl	$50, -790(%rbp)
# 51:res = t047 arg1 = i 
	leaq	-786(%rbp), %rax
	movq	%rax, -798(%rbp)
.LRT2:
	addq	$-798, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE2:
	.size	main, .-main
