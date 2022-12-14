#define ABLE_COLOR_FLAG

// Цвета
#define RESET   "\033[0m"
#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define BLACK   "\033[30m"

// Синтаксический сахар :)
#define Field std::vector<std::vector<Square>>
#define Row std::vector<Square>

#include <iostream>
#include <unistd.h>
#include <vector>

// Переменные размера, времени работы и массив потоков
int height, width, firstDelay, secondDelay;
pthread_t threads[] = {pthread_t(), pthread_t()};

// Состояние участка
enum SquareState {
    unprocessed,
    obstacle,
    firstProcessed,
    secondProcessed,
};

// Участок на поле
struct Square {
    Square() {
        pthread_mutex_init(&squareMutex, nullptr);
    }
    pthread_mutex_t squareMutex {};
    SquareState state = unprocessed;

    ~Square() {
        pthread_mutex_destroy(&squareMutex);
    }
};

// Измнение состояния клетки (если надо)
void changeSquareState(Square &square, SquareState newState) {
    if (square.state == unprocessed) {
        square.state = newState;
        newState == firstProcessed ? usleep(firstDelay) : usleep(secondDelay);
    }
}

// Имитиация длительности работы и перехода к следующей клетке садовника
void step(Square &square, SquareState newState) {
    pthread_mutex_lock(&square.squareMutex);
    changeSquareState(square, newState);
    pthread_mutex_unlock(&square.squareMutex);
    usleep(10);
}

// Логика перехода по полю
void* prepareStep(void *args) {
    Field *field = static_cast<Field*>(args);
    if (pthread_equal(threads[0], pthread_self())) {
        for (int i = 0; i < height; ++i) {
            if (i % 2 == 0) {
                for (int j = 0; j < width; ++j) {
                    step(field->at(i).at(j), firstProcessed);
                }
            } else {
                for (int j = width - 1; j != -1; --j) {
                    step(field->at(i).at(j), firstProcessed);
                }
            }
        }
    } else {
        for (int j = width - 1; j != -1; --j) {
            if (j % 2 != 0) {
                for (int i = 0; i < height; ++i) {
                    step(field->at(i).at(j), secondProcessed);
                }
            } else {
                for (int i = height - 1; i != -1; --i) {
                    step(field->at(i).at(j), secondProcessed);
                }
            }
        }
    }
    return EXIT_SUCCESS;
}

// Расстановка препятствий
void setObstacles(Field &field, size_t elementsCount) {
    srand((unsigned) time(nullptr));
    size_t randomElementsCount = 0.1 * elementsCount + ((rand() % elementsCount) * 0.2);
    while (randomElementsCount--) {
        size_t posX = rand() % height;
        size_t posY = rand() % width;
        field[posX][posY].state != obstacle ? (field[posX][posY].state = obstacle) : ++randomElementsCount;
    }
}

// Ввод данных
void inputData() {
    std::cout << "Введите размерность сада, два целых числа, через пробел:" << '\n';
    std::cin >> height >> width;
    std::cout << "Введите время работы первого и второго трудяги (в миллисекундах)" << '\n';
    std::cout << "Значение не должны быть меньше или равны 10 (скорости перемещения между полями):" << '\n';
    std::cin >> firstDelay >> secondDelay;
    if (firstDelay <= 10 || secondDelay <= 10 || height <= 0 || width <= 0) {
        std::cout << "К сожалению вы ввели некорректный данные" << '\n';
        std::cout << "Пожалуйста, введите их заново!" << '\n';
        inputData();
    }
}

// Запуск метода prepareStep в двух потоках
void startTreads(Field &field) {
    for (auto &thread : threads) {
        pthread_create(&thread, nullptr, prepareStep, (void *)&field);
    }
}

// Ожидание обоих потоков
void joinTreads() {
    for (auto thread : threads) {
        pthread_join(thread, nullptr);
    }
}

// Переопределение вывода клетки поля в консоль
std::ostream& operator <<(std::ostream &os, SquareState &state) {
    switch (state) {
        case (unprocessed):
            return os << "U";
#if defined(ABLE_COLOR_FLAG)
        case (obstacle):
            return os << BLACK << "+" << RESET;
        case (firstProcessed):
            return os << RED << "F" << RESET;
        case (secondProcessed):
            return os << GREEN << "S" << RESET;
#else
        case (obstacle):
            return os << "+";
        case (firstProcessed):
            return os << "F";
        case (secondProcessed):
            return os << "S";
#endif
    }
    return os;
}

// Переопределение вывода поля в консоль
std::ostream& operator <<(std::ostream &os, Field &field) {
    for (auto row : field) {
        for (auto square : row) {
            os << square.state << " ";
        }
        os << '\n';
    }
    return os;
}


int main() {
    inputData();
    Field field = Field(height , Row(width, Square()));
    setObstacles(field, height * width);
    startTreads(field);
    joinTreads();
    std::cout << field << '\n';
    return 0;
}