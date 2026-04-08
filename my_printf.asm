section .text

global my_printf

my_printf:
    mov eax, 4
    mov ebx, 1
    mov ecx, Msg
    mov edx, Len
    int 80h

    ret

section .data
    Msg     db "Hello, world!!"
    Len     equ $ - Msg

section .note.GNU-stack noalloc noexec nowrite progbits
