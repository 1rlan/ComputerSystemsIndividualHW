	.intel_syntax noprefix   			# Использования синтаксиса intel


	.text								
	.globl	isDigit
isDigit:								# Функция isDigit
	push	rbp							# Кладем rbp на стек	  		
	mov	rbp, rsp						# rbp = rsp				 | Не выделяем память
	mov	eax, edi						# eax = edi				 | Принимаем ch		
	mov	BYTE PTR -4[rbp], al			# [-4] = al 			 | [-4] <=> ch
	cmp	BYTE PTR -4[rbp], 57			# compare(char, 57)		 | Сравниваем коды
	jg	.L2								# goto L2				 | Если ch > 57 -> false и выход
	cmp	BYTE PTR -4[rbp], 47			# compare(char, 47)	     | Сравниваем коды
	jle	.L2								# goto L2				 | Если ch <= 47 -> false и выход
	mov	eax, 1							# return = 1			 | Иначе -> true
	jmp	.L4								# goto L4				 | Переход к метке выхода
.L2:
	mov	eax, 0							# return = 0			 | Возвращаем false
.L4:
	pop	rbp								# Удаляем rbp со стека
	ret									# return eax			 | return 0 или 1


	.globl	isNotDigit					
isNotDigit:								# Функция isNotDigit
	push	rbp							# Кладем rbp на стек	 |
	mov	rbp, rsp						# rbp - rsp				 | Не выделяем память
	mov	eax, edi						# eax = edi				 | Принимаем ch		
	mov	BYTE PTR -4[rbp], al			# [-4] = al 			 | [-4] <=> ch
	cmp	BYTE PTR -4[rbp], 57			# compare(char, 57)		 | Сравниваем коды
	jg	.L6								# goto L2				 | Если ch > 57 -> true и выход
	cmp	BYTE PTR -4[rbp], 47			# compare(char, 47)	     | Сравниваем коды
	jg	.L7								# goto L2				 | Если ch > 47 -> false и выход
.L6:	
	mov	eax, 1							# return = 1			 | Возвращаем trur
	jmp	.L9								# goto L9				 | Переход к выходу
.L7:
	mov	eax, 0							# return = 0			 | Возвращаем false
.L9:
	pop	rbp								# Удаляем rbp со стека
	ret									# return eax			 | return 0 или 1


	.globl	input
input:									# Функция isDigit
	push	rbp							# Кладем rbp на стек     |
	mov	rbp, rsp						# rbp = rsp				 | Выделяем память
	sub	rsp, 32							# rsp -= 32  			 | 

	mov	QWORD PTR -24[rbp], rdi			# [-24] = rdi			 | [-24] <=> string*
	mov	DWORD PTR -4[rbp], -1			# [-4] = -1				 | [-4] <=> size
.L11:

	add	DWORD PTR -4[rbp], 1			# [-4] += 1				 | size += 1

	call	getchar@PLT					# getchar()
	mov	edx, eax						# edx = eax 			 | edx = введенный_символ

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
count:									# Функция isDigit
	push	rbp							# Кладем rbp на стек	 |
	mov	rbp, rsp						# rbp = rsp				 | Выделяем память
	sub	rsp, 32							# rsp -= 32 			 | 

	mov	QWORD PTR -24[rbp], rdi			# [-24] = rdi			 | [-24] <=> *string
	mov	DWORD PTR -28[rbp], esi			# [-28] = esi			 | [-28] <=> length
	mov	DWORD PTR -4[rbp], 0			# [-4] = 0				 | [-4]  <=> counter
	mov	DWORD PTR -8[rbp], 1			# [-8] = 1				 | [-8]  <=> i
	jmp	.L14							# goto L14
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
	mov	eax, DWORD PTR -8[rbp]			# eax = i
	cmp	eax, DWORD PTR -28[rbp]			# compare(i, length)
	jl	.L16							# if (i < lenght) goto L16
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
main:									# Функция main
	push	rbp							# Кладем rbp на стек 	 |
	mov	rbp, rsp						# rbp = rsp			 	 | Выделение памяти
	sub	rsp, 16							# rsp -= 16			 	 |

	mov	edi, 100000						# edi = 100_000			 | Выделение памяти 			
	call	malloc@PLT					# malloc(edi)			 | под массив char'ов
	mov	QWORD PTR -8[rbp], rax			# [-8] = rax			 | [-8] <=> *string
		
	mov	rdi, QWORD PTR -8[rbp]			# rdi = [-8]			 | Вызов функции
	call	input						# input(*string)	 	 | заполнения строки
	mov	DWORD PTR -12[rbp], eax			# [-12] = eax		 	 | [-12] <=> length

	mov	esi, DWORD PTR -12[rbp]			# esi = [-12]			 | Вызов функции 
	mov	rdi, QWORD PTR -8[rbp]			# rdi = [-8]			 | подсчета чисел
	call	count						# count(*string, length) | 
	mov	DWORD PTR -16[rbp], eax			# [-16] = eax			 | [-16] <=> counter

	mov	esi, DWORD PTR -16[rbp]			# esi = [-16]			 | 
	lea	rax, .LC0[rip]					# rax = *("%d\n")		 | Вызываем printf
	mov	rdi, rax						# rdi = rax				 | со значением counter
	call	printf@PLT					# print("%d\n", counter) | 

	mov	rdi, QWORD PTR -8[rbp]			# rdi = [-8]			 | Освобождаем память 
	call	free@PLT					# free(*string)			 | из массива char'ов

	mov eax, 0
	leave								# return 0;				 | Выход из функции
	ret									
