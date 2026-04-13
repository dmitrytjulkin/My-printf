#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    MyPrintf ("Say smth cool in 3 chars: %c~~~\n", 'D');
}
