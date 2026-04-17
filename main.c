#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    // MyPrintf ("Hello, my dear friend\n");
    // MyPrintf ("BB %c%c %c%c%c%c%c\n", 'n', 'o', 'm', 'o', 'n', 'e', 'y');
    // MyPrintf ("Abacaba%sdabacaba %s \n", "gimmie", "gimme gimmy");
    MyPrintf ("Say %c%c %s \n%s~~~\n\n", 'm', 'y', "name", "yo, bro");
}
