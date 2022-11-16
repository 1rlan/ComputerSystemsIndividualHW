#include <stdio.h>
#include <math.h>

double nextStep(double prediction, double n) {
    return (2 * prediction + n / (prediction * prediction)) / 3.0;
}

double root(double number) {
    double previousStep = number / 3.0;
    double step = nextStep(previousStep, number);
    while (fabs(previousStep - step) > 0.0005) {
        previousStep = step;
        step = nextStep(previousStep, number);
    }
    return step;
}

int main() {
    double n;
    scanf("%lf", &n);
    if (n != 0) {
        printf("%lf\n", root(n));
    } else {
        printf("%d\n", 0);
    }
    return 0;
}
