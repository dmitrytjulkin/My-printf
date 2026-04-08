section .text

global my_printf

;rdi, rsi, rdx, rcx, r8, r9

my_printf:
    mov rax, 1
    mov rsi, rdi        ;rdi = first arg
    mov rdi, 1          ;stdout
    mov rdx, Len
    syscall             ;printing phrase

    ret

section .data
    Msg     db "Hello, world!!"
    Len     equ $ - Msg

section .note.GNU-stack noalloc noexec nowrite progbits
