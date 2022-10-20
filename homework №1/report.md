# Отчет

### Задание:
*Вариант №5. Сформировать массив B, состоящий из элементов массива А, значение которых не совпадает с введённым числом X.*   

### Код на языке С:
[program.c](https://github.com/1rlan/csaihw/blob/master/homework%20%E2%84%961/program.c)  - код программ\
Вводится число size - количество элементов в массиве, далее вводится. число x - элемент, который игорируется, далее вводятся size чисел. 

### Код на языке Асемблера:
[program.s](https://github.com/1rlan/csaihw/blob/master/homework%20%E2%84%961/program.s) - код без комментариев и ручного редактирования\
[clean.s](https://github.com/1rlan/csaihw/blob/master/homework%20%E2%84%961/clean.s) - код  ```program.c```  c комментариями и оптимизацией

### Флаги 
Дизасемблирование осуществлялось с использованием флагов:
```terminal
gcc -masm=intel \
    -fno-asynchronous-unwind-tables \
    -fno-jump-tables \
    -fno-stack-protector \
    -fno-exceptions \
    ./program.c \
    -S -o ./program.s
```



### Тесты 
[tests](https://github.com/1rlan/csaihw/tree/master/homework%20%E2%84%961/tests) - папка с тестами\
Для проверки корректности программы использовались тесты, проверяющие крайние значения (массивы единичной и нулевой длины), массивы четной и нечетной длины, массивы, в которых необходимо удалить каждый или не удалять вовсе, массивы с болшими положительными и отрицательными числами.

Проведем первые тесты на "чистом" ассемблерном файле и убедимся, что все работает:
![image info](images/test_first.png)

## Оптимизация и чистка файла

#### Чистка
Удалим ненужную информацию об ассемблерном файле :
```assembly
        .file   "program.c
```

```assembly
		.globl input               # в .LC0 и LC1
		.type  input, @function
```

```assembly
		.size   main, .-main
        .ident  "GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
        .section        .note.GNU-stack,"",@**progbits**
        .section        .note.gnu.property,"a"
        .align 8
        .long   1**f** - 0**f**
        .long   4**f** - 1**f**
        .long   5
0:
        .string "GNU"
1:
        .align 8
        .long   0xc0000002
        .long   3**f** - 2**f**
2:
        .long   0x3
3:
        .align 8
4:
```

