#include <stdio.h>
#include <stdlib.h>

// Проверка, является ли char цифрой
int isDigit(char ch) {
    return (ch < 58 && ch > 47);
}

// Проверка, является ли char НЕ цифрой
int isNotDigit(char ch) {
    return !(ch < 58 && ch > 47);
}

// Посимвольный ввод с клвавиатуры
int input(char* str) {
    int size = -1;
    do {
        ++size;
        str[size] = getchar();
    } while (str[size] != '\n');
    str[size] = '\0';
    return size;
}

// Подсчет чисел в строке
int count(char* string, int length) {
    int counter = 0;
    for (int i = 1; i < length; ++i) {
        if (isDigit(string[i]) && isNotDigit(string[i - 1])) {
            ++counter;
        }
    }
    if (isDigit(string[length - 1])) {
        ++counter;
    }
    return counter;
}

int main() {
    char *string = malloc(100000);
    int length = input(string);
    int counter = count(string, length);
    printf("%d\n", counter);
    free(string);
    return 0;
}
