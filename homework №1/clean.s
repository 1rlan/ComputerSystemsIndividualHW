	.intel_syntax noprefix						# Использование синтакса Intel       
	
	.text										
	.section	.rodata						# Переход в секцию констант
.LC0:											
	.string	"%d"							# Объвление строки "%d" 


	.text										
	.globl	input
input:
	push	rbp							# Кладем rbp на стек
	mov	rbp, rsp						# rbp = rsp
	sub	rsp, 32							# rsp -= 32 (выделяем память) 

	mov	QWORD PTR -24[rbp], rdi					# [-24] = old_array
	mov	DWORD PTR -28[rbp], esi					# [-28] = size
	mov	DWORD PTR -32[rbp], edx					# [-32] = x

	mov	DWORD PTR -4[rbp], 0					# valid_size = 0
	mov	r12d, 0					# i = 0	
	jmp	.L2							# goto .L2

.L4:
	mov	eax, r12d				# eax = i
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = old_array
	add	rax, rdx						# rax += rdx       

	mov	rsi, rax						# rsi = rax
	lea	rdi, .LC0[rip]						# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi
	
	mov	eax, r12d					# eax = i
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = old_array
	add	rax, rdx						# rax += rdx

	mov	eax, DWORD PTR [rax]					# eax = array[rax]	
	cmp	DWORD PTR -32[rbp], eax					# compare(x, eax)
	je	.L3							# if (x == eax) goto .L3
	add	DWORD PTR -4[rbp], 1					# ++valid_size


.L3:
	add	r12d, 1					# ++i


.L2:
	mov	eax, r12d					# eax = i
	cmp	eax, DWORD PTR -28[rbp]					# compare (eax, size)
	jl	.L4							# if (i < 4) goto .L4
	mov	eax, DWORD PTR -4[rbp]					# eax = valid_size			
	leave								# return eax
	ret
	.size	input, .-input


	.globl	make_new_array
make_new_array:
	push	rbp							# Кладем rbp на стек
	mov	rbp, rsp						# rbp = rsp

	mov	QWORD PTR -24[rbp], rdi					# [-24] = old_array
	mov	QWORD PTR -32[rbp], rsi					# [-32] = new_array
	mov	DWORD PTR -36[rbp], edx					# [-36] = size
	mov	DWORD PTR -40[rbp], ecx					# [-40] = x
	mov	DWORD PTR -4[rbp], -1					# index = -1
	mov	r12d, 0					# i = 0
	jmp	.L7							# goto .L7

.L9:
	mov	eax, r12d				# eax = i	
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = old_array
	add	rax, rdx						# rax += rdx
	mov	eax, DWORD PTR [rax]					# eax = old_array[rax]
	cmp	DWORD PTR -40[rbp], eax					# compare(old_array[rax], x)
	je	.L8							# if (old_array[rax] == x) goto .L8 

	mov	eax, r12d					# eax = i
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = old_array
	add	rax, rdx						# rax += rdx
	add	DWORD PTR -4[rbp], 1					# ++index
	mov	edx, DWORD PTR -4[rbp]					# edx = index
	movsx	rdx, edx						# rdx = edx
	lea	rcx, 0[0+rdx*4]						# rcx = rdx * 4
	mov	rdx, QWORD PTR -32[rbp]					# rdx = new_array 
	add	rdx, rcx						# rdx += rcx
	mov	eax, DWORD PTR [rax]					# eax = old_array[i]
	mov	DWORD PTR [rdx], eax					# new_array[index] = eax

.L8:
	add	r12d, 1					# ++i

.L7:
	mov	eax, r12d					# eax = i
	cmp	eax, DWORD PTR -36[rbp]					# compare(i, size)
	jl	.L9							# if (i < size) goto .L9
	pop	rbp
	ret


	.section	.rodata						# Переход в секцию констант
.LC1:
	.string	"%d "							# Объвление строки "%d " 


	.text
	.globl	output
output:
	push	rbp							# Кладем rbp на стек
	mov	rbp, rsp						# rbp = rsp
	sub	rsp, 32							# rsp -= 32 (выделяем память) 
	mov	QWORD PTR -24[rbp], rdi					# [-24] = new_array
	mov	DWORD PTR -28[rbp], esi					# [-28] = valid_size
	mov	r12d, 0					# i = 0
	jmp	.L11							# goto .L11

.L12:
	mov	eax, r12d					# eax = i
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = new_array
	add	rax, rdx						# new_array += rdx
	mov	eax, DWORD PTR [rax]					# eax = array[i]

	mov	esi, eax						# esi = array[i]
	lea	rdi, .LC1[rip]						# rdi = "%d "
call	printf@PLT							# вызов printf с параметрами

	add	r12d, 1					# ++i

.L11:
	mov	eax, r12d					# eax = i
	cmp	eax, DWORD PTR -28[rbp]					# compare (eax, valid_size)
	jl	.L12							# if (eax < valid_size) goto .L12

	mov	edi, 10							# edi = '\n' (new line)
	call	putchar@PLT						# вызываем printf c параметром
	leave
	ret



	.globl	main
main:
	push	rbp							# Кладем rbp на стек
	mov	rbp, rsp						# rbp = rsp
	sub	rsp, 88							# rsp -= 88 (выделяем память)

	push	r15									
	push	r14
	push	r13
	push	r12
	push	rbx

	mov r12, 0							# i 
	mov r13d, -92[rbp]							# size
	
	mov r14, 0
	mov r15, 0

	mov	rbx, rsp

	
	lea rsi, -92[rbp]						# rsi = &size 
	lea rdi, .LC0[rip]						# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi


	lea rsi, -96[rbp]						# rsi = &x
	lea rdi, .LC0[rip]						# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi

	mov	rax, r13						# rax = size
	shl	rax, 3							# rax *= 8
	mov rdi, rax							# rdi = rax
	call malloc@PLT							# Выделение памяти для на rax бит


	mov QWORD PTR -64[rbp], rax					# [-64] = old_array
	mov	edx, DWORD PTR -96[rbp]					# edx = x
	mov	esi, r13				# esi = size 								
	mov	rdi, QWORD PTR -64[rbp]					# rdi = old_array  
	call	input							# вызов input c аргументами	
	
	mov DWORD PTR -68[rbp], eax					# [-68] = ...
	shl rax, 3							# rax *= 8
	mov rdi, rax							# rdi = rax
	call malloc@PLT							# Выделение памяти для на rax бит
	mov QWORD PTR -88[rbp], rax					# [-88] = new_array

 	mov	ecx, DWORD PTR -96[rbp]					# ecx = x	
 	mov	edx, r13				# edx = size
 	mov	rsi, QWORD PTR -88[rbp]					# rsi = *(new_array)
 	mov	rdi, QWORD PTR -64[rbp]					# rdi = *(old_array) 
 	call	make_new_array						# вызов make_new_array c аргументами

 	mov	esi, DWORD PTR -68[rbp]					#  esi = valid_size
 	mov	rdi, QWORD PTR -88[rbp]					#  rdi = new_array
 	call	output							#  вызов output c аргументами

	mov rdi, QWORD PTR -64[rbp]					# rdi = old_array
	call free@PLT							# освобождаем память под old_array
	
	mov rdi, QWORD PTR -88[rbp]					# rdi = new_array
	call free@PLT							# освобождаем память под new_array

 	mov	rsp, rbx
 	lea	rsp, -40[rbp]

	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
