	.intel_syntax noprefix
	.text
	.globl	nextStep
	.type	nextStep, @function
nextStep:
	push	rbp
	mov	rbp, rsp
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	QWORD PTR -16[rbp], xmm1
	movsd	xmm0, QWORD PTR -8[rbp]
	movapd	xmm1, xmm0
	addsd	xmm1, xmm0
	movsd	xmm0, QWORD PTR -8[rbp]
	movapd	xmm2, xmm0
	mulsd	xmm2, xmm0
	movsd	xmm0, QWORD PTR -16[rbp]
	divsd	xmm0, xmm2
	addsd	xmm0, xmm1
	movsd	xmm1, QWORD PTR .LC0[rip]
	divsd	xmm0, xmm1
	movq	rax, xmm0
	movq	xmm0, rax
	pop	rbp
	ret
	.globl	root
	
root:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 24
	movsd	QWORD PTR -24[rbp], xmm0
	movsd	xmm0, QWORD PTR -24[rbp]
	movsd	xmm1, QWORD PTR .LC0[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	nextStep
	movq	rax, xmm0
	mov	QWORD PTR -16[rbp], rax
	jmp	.L4
.L5:
	movsd	xmm0, QWORD PTR -16[rbp]
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	nextStep
	movq	rax, xmm0
	mov	QWORD PTR -16[rbp], rax
.L4:
	movsd	xmm0, QWORD PTR -8[rbp]
	subsd	xmm0, QWORD PTR -16[rbp]
	movq	xmm1, QWORD PTR .LC1[rip]
	andpd	xmm0, xmm1
	comisd	xmm0, QWORD PTR .LC2[rip]
	ja	.L5
	movsd	xmm0, QWORD PTR -16[rbp]
	movq	rax, xmm0
	movq	xmm0, rax
	leave
	ret
	.section	.rodata
.LC3:
	.string	"%lf"
.LC5:
	.string	"%lf\n"
.LC6:
	.string	"%d\n"
	
	.text
	.globl	main

main:
	push	rbp                                    #
	mov	rbp, rsp                                   # Выделяем память под функцию
	sub	rsp, 16                                    # 

	mov	rsi, -8[rbp]
	lea	rax, .LC3[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	movsd	xmm0, QWORD PTR -8[rbp]
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	jp	.L12
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	je	.L8
.L12:
	mov	rax, QWORD PTR -8[rbp]
	movq	xmm0, rax
	call	root
	movq	rax, xmm0
	movq	xmm0, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	jmp	.L10
.L8:
	mov	esi, 0
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
.L10:
	mov	eax, 0
	leave
	ret
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1074266112
	.align 16
.LC1:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.align 8
.LC2:
	.long	-755914244
	.long	1061184077
	