section .text

global my_printf

;rdi, rsi, rdx, rcx, r8, r9

my_printf:
    call str_len

    mov rdx, rax        ;rdx = strlen
    mov rax, 1          ;write syscall
    mov rsi, rdi        ;rdi = first arg
    mov rdi, 1          ;stdout
    syscall             ;printing phrase

    ret
;________________________________________________________________

;________________________________________________________________
str_len:
    xor rdx, rdx
    dec rdx
    xor rbx, rbx

repeat:
    inc rdx
    mov bl, [rdi + rdx]
    mov [reg_val], bl

;    mov rax, 1
;    mov rdi, 1
;    mov rsi, reg_val
;    mov rdx, 2
;    syscall             ;printing val of rbx

    cmp rbx, 0
    jne repeat

    mov rax, rdx

    ret
;________________________________________________________________

section .data
    Msg     db "Hello, world!!", 0
    Len     equ $ - Msg

    reg_val db 0, NEW_LINE

    NEW_LINE    equ 0Ah
    SPACE       equ 20h

section .note.GNU-stack noalloc noexec nowrite progbits
