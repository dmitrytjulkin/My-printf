section .text

global MyPrintf

;rdi, rsi, rdx, rcx, r8, r9

MyPrintf:
    call ParseStr

;    mov rdx, rax        ;rdx = strlen
;    mov rax, 1          ;write syscall
;    mov rsi, rdi        ;rdi = first arg
;    mov rdi, 1          ;stdout
;    syscall             ;printing phrase

    ret
;________________________________________________________________

;________________________________________________________________
ParseStr:
    dec rdi
    xor rbx, rbx

repeat_to_the_end:
    inc rdi
    mov bl, [rdi]

    cmp bl, 25h                        ;the  '%'
    jne print_as_usual

    inc rdi
    mov bl, [rdi]                      ;the next symbol

    cmp bl, 63h                        ; the 'c'
    jne print_non_char
    call ParseChar
    jmp finish_cycle_step
print_non_char:

print_as_usual:
    call SymbolOutput

finish_cycle_step:
    cmp rbx, 0
    jne repeat_to_the_end

;    mov rax, rdi

    ret
;________________________________________________________________

;________________________________________________________________
SymbolOutput:
    push rdi
    push rsi
    push rdx            ;save regs values

    mov rax, 1          ;write syscall
    mov rsi, rdi        ;rsi - char to print
    mov rdx, 1          ;rdx = strlen
    mov rdi, 1          ;stdout
    syscall             ;printing symbol

    pop rdx
    pop rsi
    pop rdi

    ret
;________________________________________________________________

;________________________________________________________________
ParseChar:
    push rdi

    mov [reg_val], rsi
    mov rdi, reg_val                   ;print 2nd argument
    call SymbolOutput

    pop rdi

    ret
;________________________________________________________________

section .data
    Msg     db "Hello, world!!", 0
    Len     equ $ - Msg

    reg_val db 0, NEW_LINE

    NEW_LINE    equ 0Ah
    SPACE       equ 20h

section .note.GNU-stack noalloc noexec nowrite progbits
