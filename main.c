#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    // MyPrintf ("%x\n%o\n%b\n", 0xdadd1, 012675340000, 0b0101010101);
    // MyPrintf ("Hello, my dear friend\n");
    // MyPrintf("%s,soooooooooo\n %s", "ahahahaha", "suiiiii");
    // MyPrintf ("%c%c%c%c%c%c%c%c%c\n", 'b', 'b', 'n', 'o', 'm', 'o', 'n', 'e', 'y');
    // MyPrintf ("Abacaba%sdabacaba %s \n", "gimmie", "gimme gimmy");
    // MyPrintf ("Say %c%c %s \n%s~~~\n\n", 'm', 'y', "name", "yo, bro");
}
