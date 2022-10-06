#include <stdio.h>
#include <stdlib.h>

void input(int *array, int size) {
    for (int i = 0; i < size; ++i) {
        scanf("%d", &array[i]);
    }
}

void make_new_array(int* old_array, int *new_array, int size) {
    for (int i = 0, j = 0; i < (size + 1) / 2 && j < size; ++i) {
        new_array[i] = old_array[j];
        j += 2;
    }
    for (int i = (size + 1) / 2, j = 1; i < size && j < size; ++i) {
        new_array[i] = old_array[j];
        j += 2;
    }
}

void output(int *array, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d", array[i]);
        if (i != size - 1) {
            printf(" ");
        } else {
            printf("\n");
        }
    }
}

int main() {
    int n;
    scanf("%d", &n);

    int old_array[n];
    int new_array[n];

    input(old_array, n);
    make_new_array(old_array, new_array, n);
    output(new_array, n);

    return 0;
}