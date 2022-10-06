#include <stdio.h>

int input(int *array, int size, int notvalid) {
    int counter = 0;
    for (int i = 0; i < size; ++i) {
        scanf("%d", &array[i]);
        if (array[i] != notvalid) {
            ++counter;
        }
    }
    return counter;
}

void make_new_array(int* old_array, int *new_array, int size, int notvalid) {
    int index = -1;
    for (int i = 0; i < size; ++i) {
        if (old_array[i] != notvalid) {
            ++index;
            new_array[index] = old_array[i];
        }
    }
}

void output(int *array, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
}

int main() {
    int size, notvalid;
    scanf("%d", &size);
    scanf("%d", &notvalid);
    int old_array[size];
    int newsize = input(old_array, size, notvalid);
    int new_array[newsize];
    make_new_array(old_array, new_array, size, notvalid);
    output(new_array, newsize);
    return 0;
}