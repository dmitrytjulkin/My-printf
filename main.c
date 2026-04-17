#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    MyPrintf ("BB %c%c money\n", 'n', 'o');
    // MyPrintf ("Say %c%c %s \n%s~~~\n\n", 'm', 'y', "name", "yo, bro");
}
