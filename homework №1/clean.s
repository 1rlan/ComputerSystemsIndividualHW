	.intel_syntax noprefix						# Использование синтакса Intel       
	
	.text										# Переход в секцию с кодом
	.section	.rodata							# Переход в секцию констант
.LC0:											# Объявление метки .LC0
	.string	"%d"								# Объвление строки "%d" 

	.text										# Переход в секцию с кодом
	.globl	input
	# .type	input, @function


input:

	push	rbp									# Кладем rbp на стек
	mov	rbp, rsp								# rbp = rsp
	sub	rsp, 32									# rsp -= 32 (выделяем память) 

	mov	QWORD PTR -24[rbp], rdi					# [-24] = old_array
	mov	DWORD PTR -28[rbp], esi					# [-28] = size
	mov	DWORD PTR -32[rbp], edx					# [-32] = x

	mov	DWORD PTR -4[rbp], 0					# valid_size = 0
	mov	DWORD PTR -8[rbp], 0					# i = 0	
	jmp	.L2										# goto .L2

.L4:
	mov	eax, DWORD PTR -8[rbp]					# eax = i
	lea	rdx, 0[0+rax*4]							# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = old_array
	add	rax, rdx								# rax += rdx       
	mov	rsi, rax								# rsi = rax

	lea	rdi, .LC0[rip]							# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi
	
	mov	eax, DWORD PTR -8[rbp]					# eax = i
	lea	rdx, 0[0+rax*4]							# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = old_array
	add	rax, rdx								# rax += rdx

	mov	eax, DWORD PTR [rax]					# eax = array[rax	
	cmp	DWORD PTR -32[rbp], eax					# compare(x, eax)
	je	.L3										# if (x == eax) goto .L3
	add	DWORD PTR -4[rbp], 1					# ++valid_size



.L3:
	add	DWORD PTR -8[rbp], 1					# ++i



.L2:
	mov	eax, DWORD PTR -8[rbp]					# eax = i
	cmp	eax, DWORD PTR -28[rbp]					# compare (eax, size)
	jl	.L4										# if (i < 4) goto .L4
	mov	eax, DWORD PTR -4[rbp]					# eax = valid_size			
	leave										# return eax
	ret
	.size	input, .-input


	.globl	make_new_array
	# .type	make_new_array, @function
make_new_array:
	# endbr64
	push	rbp									# Кладем rbp на стек
	mov	rbp, rsp								# rbp = rsp
	mov	QWORD PTR -24[rbp], rdi						
	mov	QWORD PTR -32[rbp], rsi
	mov	DWORD PTR -36[rbp], edx
	mov	DWORD PTR -40[rbp], ecx					
	mov	DWORD PTR -4[rbp], -1					# index = -1
	mov	DWORD PTR -8[rbp], 0					# i = 0
	jmp	.L7


.L9:
	mov	eax, DWORD PTR -8[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -40[rbp], eax
	je	.L8
	mov	eax, DWORD PTR -8[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	add	DWORD PTR -4[rbp], 1
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	mov	rdx, QWORD PTR -32[rbp]
	add	rdx, rcx
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
.L8:
	add	DWORD PTR -8[rbp], 1
.L7:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jl	.L9
	nop
	nop
	pop	rbp
	ret
	.size	make_new_array, .-make_new_array
	.section	.rodata
.LC1:
	.string	"%d "
	.text
	.globl	output
	# .type	output, @function
output:
	# endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -28[rbp], esi
	mov	DWORD PTR -4[rbp], 0
	jmp	.L11
.L12:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	mov	esi, eax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	add	DWORD PTR -4[rbp], 1
.L11:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jl	.L12
	mov	edi, 10
	call	putchar@PLT
	nop
	leave
	ret
	.size	output, .-output
	.globl	main
	# .type	main, @function
main:
	# endbr64
	push	rbp									# Кладем rbp на стек
	mov	rbp, rsp								# rbp = rsp
	sub	rsp, 88									# rsp -= 88 (выделяем память)

	push	r15									
	push	r14
	push	r13
	push	r12
	push	rbx

	mov	rax, rsp
	mov	rbx, rax

	
	lea rsi, -92[rbp]							# rsi = &size 
	lea rdi, .LC0[rip]							# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi


	lea rsi, -96[rbp]							# rsi = &x
	lea rdi, .LC0[rip]							# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi

	mov	rax, -92[rbp]
	shl	rax, 3
	mov rdi, rax
	call malloc@PLT
	mov QWORD PTR -64[rbp], rax

	mov	edx, DWORD PTR -96[rbp]					# edx = x
	mov	esi, DWORD PTR -92[rbp]					# esi = size 								
	mov	rdi, QWORD PTR -64[rbp]					# rdi = old_array  
	call	input								# вызов input c аргументами			
	
	mov DWORD PTR -68[rbp], eax					# [-72] = valid_size
	shl rax, 3
	mov rdi, rax
	call malloc@PLT
	mov QWORD PTR -88[rbp], rax

 	mov	ecx, DWORD PTR -96[rbp]					# ecx = x	
 	mov	edx, DWORD PTR -92[rbp]					# edx = size
 	mov	rsi, QWORD PTR -88[rbp]					# rsi = *(new_array)
 	mov	rdi, QWORD PTR -64[rbp]					# rdi = *(old_array) 
 	call	make_new_array						# вызов make_new_array c аргументами

 	mov	esi, DWORD PTR -68[rbp]					# edx = valid_size
 	mov	rdi, QWORD PTR -88[rbp]					# rax = *(new_array)
 	call	output								# вызов output c аргументами

	mov rdi, QWORD PTR -64[rbp]
	call free@PLT

	mov rdi, QWORD PTR -88[rbp]
	call free@PLT

 	mov	rsp, rbx
 	lea	rsp, -40[rbp]

	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
