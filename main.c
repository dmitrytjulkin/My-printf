#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    // MyPrintf ("BB %c%c %c%c%c%c%c\n", 'n', 'o', 'm', 'o', 'n', 'e', 'y');
    MyPrintf ("BB %s money\n", "here");
    // MyPrintf ("Say %c%c %s \n%s~~~\n\n", 'm', 'y', "name", "yo, bro");
}
