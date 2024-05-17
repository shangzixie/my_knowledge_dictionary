#include <stdio.h>

int main() {
    unsigned int num = 255;
    int count = 1;
    for (int i =31; i >= 0; i--) {
        if (count % 4 == 0) {
            printf("%d, ", (num >> i) && 1);
        } else {
            printf("%d", (num >> i) && 1);
        }
        count += 1;
    }

    return 0;
}
