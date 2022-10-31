	.intel_syntax noprefix


	.text
	.globl	isDigit
isDigit:
	push	rbp
	mov	rbp, rsp
	mov	eax, edi
	mov	BYTE PTR -4[rbp], al
	cmp	BYTE PTR -4[rbp], 57
	jg	.L2
	cmp	BYTE PTR -4[rbp], 47
	jle	.L2
	mov	eax, 1
	jmp	.L4
.L2:
	mov	eax, 0
.L4:
	pop	rbp
	ret


	.globl	isNotDigit
isNotDigit:
	push	rbp
	mov	rbp, rsp
	mov	eax, edi
	mov	BYTE PTR -4[rbp], al
	cmp	BYTE PTR -4[rbp], 57
	jg	.L6
	cmp	BYTE PTR -4[rbp], 47
	jg	.L7
.L6:
	mov	eax, 1
	jmp	.L9
.L7:
	mov	eax, 0
.L9:
	pop	rbp
	ret


	.globl	input
input:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -4[rbp], -1
.L11:
	add	DWORD PTR -4[rbp], 1
	call	getchar@PLT
	mov	edx, eax
	mov	eax, DWORD PTR -4[rbp]
	movsx	rcx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rcx
	mov	BYTE PTR [rax], dl
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	jne	.L11
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	BYTE PTR [rax], 0
	mov	eax, DWORD PTR -4[rbp]
	leave
	ret


	.globl	count
count:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -28[rbp], esi
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 1
	jmp	.L14
.L16:
	mov	eax, DWORD PTR -8[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	mov	edi, eax
	call	isDigit
	test	eax, eax
	je	.L15
	mov	eax, DWORD PTR -8[rbp]
	lea	rdx, -1[rax]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	mov	edi, eax
	call	isNotDigit
	test	eax, eax
	je	.L15
	add	DWORD PTR -4[rbp], 1
.L15:
	add	DWORD PTR -8[rbp], 1
.L14:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jl	.L16
	mov	eax, DWORD PTR -28[rbp]
	lea	rdx, -1[rax]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	mov	edi, eax
	call	isDigit
	test	eax, eax
	je	.L17
	add	DWORD PTR -4[rbp], 1
.L17:
	mov	eax, DWORD PTR -4[rbp]
	leave
	ret


	.section	.rodata
.LC0:
	.string	"%d\n"


	.text
	.globl	main
main:
	push	rbp							# Кладем rbp на стек |
	mov	rbp, rsp						# rbp = rsp			 | Выделение памяти
	sub	rsp, 16							# rsp -= 16			 |

	mov	edi, 100000						# edi = 100_000		 | Выделение памяти 			
	call	malloc@PLT					# malloc(edi)		 | под массив char'ов
	mov	QWORD PTR -8[rbp], rax			# [-8] = rax		 | [-8] <=> *string
		
	mov	rdi, QWORD PTR -8[rbp]			# rdi = [-8]		 | Вызов функции
	call	input						# input(*string)	 | заполнения строки
	mov	DWORD PTR -12[rbp], eax			# [-12] = eax		 | [-12] <=> length


	mov	edx, DWORD PTR -12[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	esi, edx
	mov	rdi, rax
	call	count
	mov	DWORD PTR -16[rbp], eax

	mov	eax, DWORD PTR -16[rbp]
	mov	esi, eax
	
	mov	rdi, .LC0[rip]					
	mov	eax, 0
	call	printf@PLT

	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	call	free@PLT
	mov	eax, 0
	leave
	ret
