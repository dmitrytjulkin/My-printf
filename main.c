#include <stdio.h>
#include <stdarg.h>

extern void my_printf(const char* str);

int main ()
{
    printf ("Hello there\n\n");

    my_printf ("Myname is Giovanni Giorgio, but everybody calls me Giorgio\n");
}
