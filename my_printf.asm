section .text

global MyPrintf

;rdi, rsi, rdx, rcx, r8, r9

MyPrintf:
    dec rdi
    xor rbx, rbx
    xor r10, r10            ;specifiers counter
    dec r10

repeat_to_the_end:
    inc rdi
    mov bl, [rdi]

    cmp bl, 25h             ;the  '%'
    jne print_just_symbol

    inc r10
    inc rdi
    mov bl, [rdi]           ;the next symbol

    cmp bl, 63h             ; the 'c'
    jne print_non_char
    call ParseChar
    jmp finish_cycle_step
print_non_char:

    cmp bl, 73h             ; the 's'
    jne print_non_string
;    call ParseString
    jmp finish_cycle_step
print_non_string:

print_just_symbol:
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
    push rdx                ;save regs values
    push rcx

    mov rax, 1              ;write syscall
    mov rsi, rdi            ;rsi - char to print
    mov rdx, 1              ;rdx = strlen
    mov rdi, 1              ;stdout
    syscall                 ;printing symbol

    pop rcx
    pop rdx
    pop rsi
    pop rdi

    ret
;________________________________________________________________

;________________________________________________________________
ParseChar:
    push rdi

    call ChooseRegToParse
    mov [reg_val], al
    mov rdi, reg_val        ;print 2nd argument
    call SymbolOutput

    pop rdi

    ret
;________________________________________________________________

;r10 contains count specifiers that was passed
;________________________________________________________________
ChooseRegToParse:
    cmp r10, 0
    jne not_rsi
    mov rax, rsi
    jmp go_ret
not_rsi:

    cmp r10, 1
    jne not_rdx
    mov rax, rdx
    jmp go_ret
not_rdx:

    cmp r10, 2
    jne not_rcx
    mov rax, rcx
    jmp go_ret
not_rcx:

    cmp r10, 3
    jne not_r8
    mov rax, r8
    jmp go_ret
not_r8:

    cmp r10, 4
    jne not_r9
    mov rax, r9
    jmp go_ret
not_r9:

    pop rcx             ;ret for ChooseRegToParse
    pop rdx             ;ret for ParseChar
    pop rax             ;our argument

    push rdx
    push rcx

go_ret:
    ret

;________________________________________________________________

section .data
    Msg     db "Hello, world!!", 0
    Len     equ $ - Msg

    reg_val db 0, NEW_LINE

    NEW_LINE    equ 0Ah
    SPACE       equ 20h

section .note.GNU-stack noalloc noexec nowrite progbits
