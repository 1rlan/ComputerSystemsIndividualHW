	.intel_syntax noprefix						# Использование синтакса Intel       
	
	.text										
	.section	.rodata						# Переход в секцию констант
.LC0:											
	.string	"%d"							# Объвление строки "%d" 


	.text										
	.globl	input
input:
	push	rbp								# Кладем rbp на стек
	mov	rbp, rsp							# rbp = rsp
	sub	rsp, 64								# rsp -= 32 (выделяем память) 

	mov	QWORD PTR -24[rbp], rdi					# [-24] = old_array
	mov	QWORD PTR -32[rbp], rsi					# [-28] = size
	mov	QWORD PTR -40[rbp], rdx					# [-32] = x

	mov	QWORD PTR -8[rbp], 0		# valid_size = 0
	mov	r12, 0						# i = 0	
	jmp	.L2							# goto .L2

// 5 2
// 1 2 2 4 5

.L4:
	mov	rax, r12						# eax = i
	lea	rdx, 0[0+rax*4]					# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]			# rax = old_array
	add	rax, rdx						# rax += rdx       

	mov	rsi, rax						# rsi = rax
	lea	rdi, .LC0[rip]					# rdi = "%d"
	call	__isoc99_scanf@PLT			# Вызов функции scanf c параметрами rsi и rdi
	
	mov	rax, r12						# eax = i
	lea	rdx, 0[0+rax*4]					# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]			# rax = old_array
	add	rax, rdx						# rax += rdx

	mov	rax, QWORD PTR [rax]			# eax = array[rax]	
	cmp	QWORD PTR -40[rbp], rax			# compare(x, eax)
	je	.L3								# if (x == eax) goto .L3
	add	QWORD PTR -8[rbp], 1			# ++valid_size

.L3:
	add	r12, 1					# ++i

.L2:
	mov	rax, r12					# eax = i
	cmp	rax, QWORD PTR -32[rbp]					# compare (eax, size)
	jl	.L4							# if (i < 4) goto .L4
	mov	rax, QWORD PTR -8[rbp]					# eax = valid_size			
	leave								# return eax
	ret
	.size	input, .-input


	.globl	make_new_array
make_new_array:
	push	rbp							# Кладем rbp на стек
	mov	rbp, rsp						# rbp = rsp

	mov	QWORD PTR -24[rbp], rdi					# [-24] = old_array
	mov	QWORD PTR -32[rbp], rsi					# [-32] = new_array
	mov	QWORD PTR -40[rbp], rdx					# [-36] = size
	mov	QWORD PTR -48[rbp], rcx					# [-40] = x
	mov	QWORD PTR -8[rbp], -1					# index = -1
	mov	r12, 0					# i = 0
	jmp	.L7							# goto .L7

.L9:
	mov	rax, r12							# eax = i	
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]				# rax = old_array
	add	rax, rdx							# rax += rdx
	mov	rax, QWORD PTR [rax]				# eax = old_array[rax]
	cmp	QWORD PTR -48[rbp], rax				# compare(old_array[rax], x)
	je	.L8									# if (old_array[rax] == x) goto .L8 

	mov	rdi, 33							# edi = '\n' (new line)
	call	putchar@PLT						# вызываем printf c параметром

	mov	rax, r12							# eax = i
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]				# rax = old_array
	add	rax, rdx							# rax += rdx
	add	QWORD PTR -8[rbp], 1				# ++index
	mov	rdx, QWORD PTR -8[rbp]				# edx = index
	lea	rcx, 0[0+rdx*4]						# rcx = rdx * 4
	mov	rdx, QWORD PTR -32[rbp]				# rdx = new_array 
	add	rdx, rcx							# rdx += rcx
	mov	rax, QWORD PTR [rax]				# eax = old_array[i]
	mov	QWORD PTR [rdx], rax				# new_array[index] = eax

.L8:
	add	r12, 1					# ++i

.L7:
	mov	rax, r12					# eax = i
	cmp	rax, QWORD PTR -40[rbp]					# compare(i, size)
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
	sub	rsp, 64							# rsp -= 32 (выделяем память) 
	mov	QWORD PTR -24[rbp], rdi					# [-24] = new_array
	mov	QWORD PTR -32[rbp], rsi					# [-28] = valid_size
	mov	r12, 0					# i = 0
	jmp	.L11							# goto .L11

.L12:
	mov	rax, r12					# eax = i
	lea	rdx, 0[0+rax*4]						# rdx = rax * 4
	mov	rax, QWORD PTR -24[rbp]					# rax = new_array
	add	rax, rdx						# new_array += rdx
	mov	rax, QWORD PTR [rax]					# eax = array[i]

	mov	rsi, rax						# esi = array[i]
	lea	rdi, .LC1[rip]						# rdi = "%d "
	call	printf@PLT							# вызов printf с параметрами

	add	r12, 1					# ++i

.L11:
	mov	rax, r12					# eax = i
	cmp	rax, QWORD PTR -32[rbp]					# compare (eax, valid_size)
	jl	.L12							# if (eax < valid_size) goto .L12

	mov	rdi, 10							# edi = '\n' (new line)
	call	putchar@PLT						# вызываем printf c параметром
	leave
	ret



	.globl	main
main:
	push	rbp							# Кладем rbp на стек
	mov	rbp, rsp						# rbp = rsp
	sub	rsp, 120							# rsp -= 88 (выделяем память)

	push	r15									
	push	r14
	push	r13
	push	r12
	push	rbx

	mov r12, 0

	mov	rbx, rsp

	
	lea rsi, -96[rbp]						# rsi = &size 
	lea rdi, .LC0[rip]						# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi


	lea rsi, -104[rbp]						# rsi = &x
	lea rdi, .LC0[rip]						# rdi = "%d"
	call	__isoc99_scanf@PLT					# Вызов функции scanf c параметрами rsi и rdi

	mov	rax, -96[rbp]						# rax = size
	shl	rax, 3								# rax *= 8
	mov rdi, rax							# rdi = rax
	call malloc@PLT							# Выделение памяти для на rax бит
	mov QWORD PTR -64[rbp], rax				# [-64] = old_array

	mov	rdx, QWORD PTR -104[rbp]			# edx = x
	mov	rsi, QWORD PTR -96[rbp]				# esi = size 								
	mov	rdi, QWORD PTR -64[rbp]				# rdi = old_array  
	call	input							# вызов input c аргументами	
	mov QWORD PTR -72[rbp], rax				# [-68] = ...

	shl rax, 3								# rax *= 8
	mov rdi, rax							# rdi = rax
	call malloc@PLT							# Выделение памяти для на rax бит
	mov QWORD PTR -80[rbp], rax				# [-88] = new_array

 	mov	rcx, QWORD PTR -104[rbp]			# ecx = x	
 	mov	rdx, QWORD PTR -96[rbp]				# edx = size
 	mov	rsi, QWORD PTR -80[rbp]				# rsi = *(new_array)
 	mov	rdi, QWORD PTR -64[rbp]				# rdi = *(old_array) 
 	call	make_new_array					# вызов make_new_array c аргументами

 	mov	rsi, QWORD PTR -72[rbp]				#  esi = valid_size
 	mov	rdi, QWORD PTR -80[rbp]				#  rdi = new_array
 	call	output							#  вызов output c аргументами

	mov rdi, QWORD PTR -80[rbp]				# rdi = old_array
	call free@PLT							# освобождаем память под old_array
	
	mov rdi, QWORD PTR -64[rbp]				# rdi = new_array
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
