	.intel_syntax noprefix   			# Использования синтаксиса intel

	.text								
	.globl	isDigit
isDigit:								# Функция isDigit		 |
	push	rbp							# Кладем rbp на стек	 | Не выделяем память	
	mov	rbp, rsp						# rbp = rsp				 | 
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
isNotDigit:								# Функция isNotDigit     |
	push	rbp							# Кладем rbp на стек	 | Не выделяем память
	mov	rbp, rsp						# rbp - rsp				 | 
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
	mov	eax, DWORD PTR -4[rbp]			# eax = [-4]			 | eax = size			 
	movsx	rcx, eax					# rcx = eax				 | rcx = size c расширением
	mov	rax, QWORD PTR -24[rbp]			# rax = [-24]			 | rax = *string			 
	add	rax, rcx						# rax += rcx			 | *string += size
	mov	BYTE PTR [rax], dl				# string[rax] = char	 | *string = (char from getchar)	
	mov	eax, DWORD PTR -4[rbp]			# eax = [-4] 			 | eax = size
	movsx	rdx, eax					# rdx = eax				 | rdx = size c расширением
	mov	rax, QWORD PTR -24[rbp]			# rax = [-24]	     	 | rax = *string
	add	rax, rdx						# rax += rdx			 | rax += size
	movzx	eax, BYTE PTR [rax]			# eax = string[rax]		 | eax = string[rax]
	cmp	al, 10							# compare(eax, 10)		 | Если char == "\n" - выходим 
	jne	.L11							# goto L11				 | Выход из while
	mov	eax, DWORD PTR -4[rbp]			# eax = [-4]			 | eax = size
	movsx	rdx, eax					# rdx = eax				 | rdx = size
	mov	rax, QWORD PTR -24[rbp]			# rax = [-24]			 | rax = *string
	add	rax, rdx						# rax += rdx			 | rax += size
	mov	BYTE PTR [rax], 0				# string[rax] = 0		 | string[rax] = '\0'
	mov	eax, DWORD PTR -4[rbp]			# eax = [-4]			 | eax = size
	leave								# return eax
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
	mov	eax, DWORD PTR -8[rbp]			# eax = [-8]			 | eax = i				
	movsx	rdx, eax					# rdx = eax				 | rdx = i
	mov	rax, QWORD PTR -24[rbp]			# rax = *[-24]           | rax = *string
	add	rax, rdx						# rax += rdx             | string += i
	movzx	eax, BYTE PTR [rax]			# eax = array[rax]       | eax = string[rax]
	movsx	eax, al						# eax 				     | eax = al([char])
	mov	edi, eax						# edi = eax				 | edi = char
	call	isDigit						# isDigit(edi)			 | Проверка на цифру 
	test	eax, eax					# if (eax == 0)			 | Если цифра, то проваливаемся 
	je	.L15							# goto L15				 | Иначе - следующая итеарация
	mov	eax, DWORD PTR -8[rbp]			# eax = i 				 | eax = i 
	lea	rdx, -1[rax]					# rdx = *array[rax]		 | rdx = [rax]
	mov	rax, QWORD PTR -24[rbp]			# rax = [-24]			 | rax = *string
	add	rax, rdx						# rax += rdx			 | rax += rdx
	movzx	eax, BYTE PTR [rax]			# eax = string[rax] 	 | eax = string[rax]
	movsx	eax, al						# eax = al([char])		 | eax = al([char])
	mov	edi, eax						# edi = eax				 | edi = char
	call	isNotDigit					# isNotDigit(edi)		 | Проверка на НЕ цифру 
	test	eax, eax					# if (eax == 0)			 | Если не цифра, то увеличиваем counter 
	je	.L15							# goto L15				 | Иначе - следующая итерация
	add	DWORD PTR -4[rbp], 1			# [-4] += 1				 | ++counter
.L15:
	add	DWORD PTR -8[rbp], 1			# [-8] += 1				 | ++i

.L14:
	mov	eax, DWORD PTR -8[rbp]			# eax = [-8]			 |eax = i
	cmp	eax, DWORD PTR -28[rbp]			# compare(i, length)	 | если i < length 
	jl	.L16							#						 | итерируемся дальше
	lea	rdx, -1[rax]					# rdx = *array[rax]		 | rdx = [rax]
	mov	rax, QWORD PTR -24[rbp]			# rax = [-24]			 | rax = string
	add	rax, rdx						# rax += rdx			 | rax += [rax]
	movzx	eax, BYTE PTR [rax]			# eax = string[rax]		 | eax = char
	movsx	eax, al						# eax = al([char])		 | eax = al([char])
	mov	edi, eax						# edi = eax				 | edi = char
	call	isDigit						# isDigit(edi)			 | Проверка на цифру 
	test	eax, eax					# compare (value, 0)	 | if (equal) -> return section
	je	.L17							# goto L17				 | иначе прибавляем счетчик
	add	DWORD PTR -4[rbp], 1			# [-4] += 1				 | counter++
.L17:
	mov	eax, DWORD PTR -4[rbp]			# eax = counter			 | return = counter
	leave								# return counter		
	ret

	.section	.rodata					# Секция констант
.LC0:
	.string	"%d\n"						# Строка :P

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
