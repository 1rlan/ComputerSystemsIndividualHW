	.intel_syntax noprefix
	.text
	.globl	nextStep

nextStep:
	push	rbp                                    # Выделяем память под функцию
	mov	rbp, rsp                                   #

	movsd	QWORD PTR -8[rbp], xmm0                # [-8] = prediction
	movsd	QWORD PTR -16[rbp], xmm1               # [-16] = n

	movsd	xmm0, QWORD PTR -8[rbp]                # xmm0 = prediction
	movapd	xmm1, xmm0                             # xmm1 = prediction
	addsd	xmm1, xmm0                             # xmm1 += prediction             | (2 * prediction)

	movsd	xmm0, QWORD PTR -8[rbp]                # xmm0 = prediction
	movapd	xmm2, xmm0                             # xmm2 = prediction
	mulsd	xmm2, xmm0                             # xmm2 *= xmm0                   | (prediction * prediction)

	movsd	xmm0, QWORD PTR -16[rbp]               # xmm0 = n
	divsd	xmm0, xmm2                             # xmm0 /= xmm2                   | (n / (prediction * prediction))

	addsd	xmm0, xmm1                             # xmm0 += xmm1                   | (2 * prediction) + (n / (prediction * prediction))

	movsd	xmm1, QWORD PTR .LC0[rip]              # xmm1 = 3.0
	divsd	xmm0, xmm1                             # xmm0 /= xmm1                   | ((2 * prediction) + (n / (prediction * prediction))) / 3.0

	movq	rax, xmm0                              # rax = xmm0 
	movq	xmm0, rax
	pop	rbp
	ret

	.globl	root
root:
	push	rbp                                    #                      
	mov	rbp, rsp                                   # Выделяем память под функцию
	sub	rsp, 24                                    #

	movsd	QWORD PTR -24[rbp], xmm0               # [-24] = number

	movsd	xmm0, QWORD PTR -24[rbp]               # xmm0 = number
	movsd	xmm1, QWORD PTR .LC0[rip]              # xmm1 = 3
	divsd	xmm0, xmm1                             # xmm0 /= 3
	movsd	QWORD PTR -8[rbp], xmm0                # previousStep = xmm0  

	movsd	xmm0, QWORD PTR -24[rbp]               # xmm0 = number
	mov	rax, QWORD PTR -8[rbp]                     # rax = previousStep
	movapd	xmm1, xmm0                             # xmm1 = number
	movq	xmm0, rax                              # xmm0 = previousStep
	call	nextStep                               # nextStep(xmm0, xmm1)
	movq	rax, xmm0                              # rax = xmm0
	mov	QWORD PTR -16[rbp], rax                    # [-16] = step

	jmp	.L4
.L5:
	movsd	xmm0, QWORD PTR -16[rbp]               # xmm = step
	movsd	QWORD PTR -8[rbp], xmm0                # previousStep = step

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

	lea	rax, -8[rbp]							   
	mov	rsi, rax                                   # rsi = n
	lea	rax, .LC3[rip]
	mov	rdi, rax                                   # rdi = "%lf"
	mov	eax, 0
	call	__isoc99_scanf@PLT                     # scanf(rdi, rsi)

	
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
	