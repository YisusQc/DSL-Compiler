#include <iostream>

float sumar(float a, float b, float c) {
    return a + b + c;
}

int main() {
    float a = 1, b = 2, c = 3;
    std::cout << sumar(a, b, c) << std::endl;
    return 0;
}
