#include <stdio.h>
#include <stdlib.h>

void input(int *array, int size, int change, int counter) {
    for (int i = 0; i < size; ++i) {
        scanf("%d", &array[i]);
        if (array[i] != change) {
            ++counter;
        }
    }
}

void make_new_array(int* old_array, int *new_array, int size, int change) {
    int index = -1;
    for (int i = 0; i < change; ++i) {
        if (old_array[i] != change) {
            ++index;
            new_array[index] = old_array[i];
        }
    }

}

void output(int *array, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d", array[i]);
        printf(" ");
    }
    printf("\n");
}

int main() {
    int n, change, counter;
    scanf("%d", &n);
    scanf("%d", &change);
    int old_array[n];
    input(old_array, n, change, counter);
    int new_array[counter];
    make_new_array(old_array, new_array, n, change);
    output(new_array, n);

    return 0;
}