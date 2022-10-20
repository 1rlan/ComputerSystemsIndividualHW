#include <stdio.h>

// Заполнение массива с клавиатуры.
int input(int *array, int size, int x) {
    int valid_size = 0;
    for (int i = 0; i < size; ++i) {
        scanf("%d", &array[i]);
        if (array[i] != x) {
            // Считаем кол-во элементов, не равных x.
            ++valid_size;
        }
    }
    return valid_size;
}

// Создание нового массива на основе страого.
void make_new_array(int* old_array, int *new_array, int size, int x) {
    int index = -1;
    for (int i = 0; i < size; ++i) {
        // Присваиваем значение в новый массив, если он не равен x.
        if (old_array[i] != x) {
            new_array[++index] = old_array[i];
        }
    }
}

// Вывод элементов массива.
void output(int *array, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", array[i]);
    }
}

int main() {
    // size - размер массива.
    // x - значение, которое надо игнорировтаь.
    // valid_size - кол-во элементов в новом массиве.
    int size, x, valid_size;
    scanf("%d", &size);
    scanf("%d", &x);
    int old_array[size];
    valid_size = input(old_array, size, x);
    int new_array[valid_size];
    make_new_array(old_array, new_array, size, x);
    output(new_array, valid_size);
    return 0;
}
