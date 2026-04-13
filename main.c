#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    MyPrintf ("Say smth cool in 3 chars: %c%c%c%c%c%c%c%c%c%c%c%c%c%c~~~\n", '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E');
}
