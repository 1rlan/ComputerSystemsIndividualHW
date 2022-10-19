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


