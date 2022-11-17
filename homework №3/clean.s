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

	movq	rax, xmm0                              
	movq	xmm0, rax                              # xmm0 = valueToReturn
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
	movsd	QWORD PTR -8[rbp], xmm0                # [-8] = previousStep  

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

	movsd	xmm0, QWORD PTR -24[rbp]               # xmm0 = number
	mov	rax, QWORD PTR -8[rbp]                     # rax = previousStep
	movapd	xmm1, xmm0                             # xmm1 = number
	movq	xmm0, rax                              # xmm0 = previousStep
	call	nextStep                               # nextStep(previousStep, number)

	movq	rax, xmm0                              
	mov	QWORD PTR -16[rbp], rax                    # step = valueToReturn

.L4:
	movsd	xmm0, QWORD PTR -8[rbp]                # xmm0 = previousStep
	subsd	xmm0, QWORD PTR -16[rbp]               # xmm0 -= step

	movq	xmm1, QWORD PTR .LC1[rip]
	andpd	xmm0, xmm1                             # fabs(xmm0)

	comisd	xmm0, QWORD PTR .LC2[rip]              # compare(fabs(xmm0), epsilon)
	ja	.L5                                        # if (fabs(xmm0) > epsilon) goto .L5

	movsd	xmm0, QWORD PTR -16[rbp]               # xmm0 = step

	movq	rax, xmm0
	movq	xmm0, rax                              # xmm0 = valueToReturn (step)
	leave
	ret


	.section	.rodata                            #
.LC3:                                              #
	.string	"%lf"                                  # 
.LC5:                                              # Секция констант
	.string	"%lf\n"                                #
.LC6:                                              #
	.string	"%d\n"                                 #
	


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
	call	__isoc99_scanf@PLT                     # scanf(rdi, rsi)

	
	movsd	xmm0, QWORD PTR -8[rbp]				   # xmm0 = n
	pxor	xmm1, xmm1                             
	ucomisd	xmm0, xmm1
	jp	.L12                                       # if (xmm0 == n) goto .L12
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	je	.L8                                        # if (xmm0 != n) goto .L8


.L12:
	mov	rax, QWORD PTR -8[rbp]                     
	movq	xmm0, rax                              # xmm0 = n
	call	root                                   # root(xmm0)
	movq	rax, xmm0                              # rax = root(xmm0)

	movq	xmm0, rax                              # xmm0 = rax
	lea	rax, .LC5[rip]                             # rax = "%lf\n"
	mov	rdi, rax                                   # rdi = "%lf\n"
	# mov	eax, 1                                     #
	call	printf@PLT                             # print("%lf\n", xmm0)
	jmp	.L10

.L8:
	mov	esi, 0                                     # esi = 0
	lea	rax, .LC6[rip]                             # rax = "%d\n" 
	mov	rdi, rax                                   # rdi = rax                                 
	call	printf@PLT                             # printf("%d\n", 0)

.L10:
	leave
	ret


	.section	.rodata                            #
	.align 8                                       #
.LC0:                                              #
	.long	0                                      #
	.long	1074266112                             #
	.align 16                                      #
.LC1:                                              #
	.long	-1                                     # Секция констант
	.long	2147483647                             #
	.long	0                                      #
	.long	0                                      #
	.align 8                                       #
.LC2:                                              #
	.long	-755914244                             #
	.long	1061184077                             #
	