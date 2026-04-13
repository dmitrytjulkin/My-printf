#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    MyPrintf ("Say %c%c %s \n%s~~~\n\n", 'm', 'y', "name", "yo, bro");
}
