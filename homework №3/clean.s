	.intel_syntax noprefix                         # Синтаксис intel
	
	.text
	.globl	nextStep
nextStep:
	movsd	QWORD PTR xmm7, xmm0                # [-8] = prediction
	movsd	QWORD PTR -16[rbp], xmm1               # [-16] = n
	movapd	xmm1, xmm0                             # xmm1 = prediction
	addsd	xmm1, xmm1                             # xmm1 += prediction              | (2 * prediction)
	movapd	xmm2, xmm0                             # xmm2 = prediction
	mulsd	xmm2, xmm2                             # xmm2 *= xmm2                    | (prediction * prediction)
	movsd	xmm0, QWORD PTR -16[rbp]               # xmm0 = n
	divsd	xmm0, xmm2                             # xmm0 /= xmm2                    | (n / (prediction * prediction))
	addsd	xmm0, xmm1                             # xmm0 += xmm1                    | (2 * prediction) + (n / (prediction * prediction))
	divsd	xmm0, QWORD PTR .LC0[rip]              # xmm0 /= 3.0                     | ((2 * prediction) + (n / (prediction * prediction))) / 3.0
	ret                                            # return xmm0

	.globl	root
root:
	push	rbp                                    #                      
	mov	rbp, rsp                                   # Выделяем память под функцию
	sub	rsp, 24                                    # 
	movsd	QWORD PTR -24[rbp], xmm0               # [-24] = number
	divsd	xmm0, QWORD PTR .LC0[rip]              # xmm0 /= 3                       | number / 3.0
	movsd	QWORD PTR xmm7, xmm0                # [-8] = previousStep             | previousStep = number / 3.0
	movsd	xmm1, QWORD PTR -24[rbp]               # xmm1 = number
	call	nextStep                               # nextStep(xmm0, xmm1)
	movsd	QWORD PTR -16[rbp], xmm0               # atep = valueToReturn            | step = nextStep(previousStep, number)
	jmp	.L4
.L5:
	movsd	xmm0, QWORD PTR -16[rbp]               # xmm0 = step
	movsd	QWORD PTR xmm7, xmm0                # previousStep = step
	movsd	xmm1, QWORD PTR -24[rbp]               # xmm1 = number
	call	nextStep                               # nextStep(previousStep, number)
	movsd	QWORD PTR -16[rbp], xmm0               # step = valueToReturn            | step = nextStep(previousStep, number);
.L4:
	movsd	xmm0, QWORD PTR xmm7                # xmm0 = previousStep
	subsd	xmm0, QWORD PTR -16[rbp]               # xmm0 -= step
	movq	xmm1, QWORD PTR .LC1[rip]              # xmm1 = 0.0005
	andpd	xmm0, xmm1                             # fabs((previousStep - step), 0.005)
	comisd	xmm0, QWORD PTR .LC2[rip]              # compare(fabs(xmm0), epsilon)
	ja	.L5                                        # if (fabs(xmm0) > epsilon) goto .L5
	movsd	xmm0, QWORD PTR -16[rbp]               # return step
	leave
	ret

	.globl	main
main:
	push	rbp                                    #
	mov	rbp, rsp                                   # Выделяем память под функцию
	sub	rsp, 16                                    # 
	lea	rax, .LC3[rip]
	mov	rdi, rax                                   # rdi = "%lf"
	lea	rax, xmm7							   
	mov	rsi, rax                                   # rsi = n
	call	__isoc99_scanf@PLT                     # scanf("%lf", n)
	movsd	xmm0, QWORD PTR xmm7				   # xmm0 = n
	pxor	xmm1, xmm1                             
	ucomisd	xmm0, xmm1
	jp	.L12                                       # if (n == 0) goto .L12
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	je	.L8                                        # if (n != 0) goto .L8
.L12:                
	call	root                                   # root(xmm0)
	lea	rax, .LC5[rip]                             
	mov	rdi, rax                                   # rdi = "%lf\n"                                 
	call	printf@PLT                             # print("%lf\n", xmm0)
	jmp	.L10
.L8:
	lea	rax, .LC6[rip]                              
	mov	rdi, rax                                   # rdi = "%d\n"    
	mov	esi, 0                                     # esi = 0                             
	call	printf@PLT                             # printf("%d\n", 0)
.L10:
	leave
	ret

	.section	.rodata                            #
.LC0:                                              #
	.long	0                                      #
	.long	1074266112                             #
.LC1:                                              #
	.long	-1                                     # 
	.long	2147483647                             #
	.long	0                                      #
	.long	0                                      # Секция констант
.LC2:                                              # 
	.long	-755914244                             #
	.long	1061184077                             #
.LC3:                                              #
	.string	"%lf"                                  # 
.LC5:                                              # 
	.string	"%lf\n"                                #
.LC6:                                              #
	.string	"%d\n"                                 #
	