#include <stdio.h>
#include <stdarg.h>

extern void MyPrintf(const char* str, ...);

int main ()
{
    printf ("Hello there\n\n");

    MyPrintf ("%x\n%x\n%x\n", 0x1234, 0xbabe, 0xdadd1);
    // MyPrintf ("Hello, my dear friend\n");
    // MyPrintf("%s,soooooooooo\n %s", "ahahahaha", "suiiiii");
    // MyPrintf ("%c%c%c%c%c%c%c%c%c\n", 'b', 'b', 'n', 'o', 'm', 'o', 'n', 'e', 'y');
    // MyPrintf ("Abacaba%sdabacaba %s \n", "gimmie", "gimme gimmy");
    // MyPrintf ("Say %c%c %s \n%s~~~\n\n", 'm', 'y', "name", "yo, bro");
}
