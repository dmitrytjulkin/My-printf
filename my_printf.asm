section .text

global MyPrintf

;rdi, rsi, rdx, rcx, r8, r9

MyPrintf:
    push rbp
    mov rbp, rsp            ;rbp for addressing to args
    add rbp, 16

    mov r13, rsi            ;to use movsw:
    mov rsi, rdi            ;rsi - sentence
    mov rdi, buffer         ;rdi - buffer

    xor rbx, rbx
    xor r12, r12            ;buffer size
    xor r10, r10            ;specifiers counter
    dec r10

repeat_to_the_end:
    mov bl, [rsi]

    cmp bl, 25h             ;the  '%'
    jne print_usual_symbol

    inc r10
    inc rsi
    mov bl, [rsi]           ;the next symbol

    cmp bl, 63h             ; the 'c'
    jne print_non_char
    call ParseChar
    jmp finish_cycle_step
print_non_char:

    cmp bl, 73h             ; the 's'
    jne print_non_string
    call ParseString
    jmp finish_cycle_step
print_non_string:

print_usual_symbol:
    movsb
    inc r12

finish_cycle_step:
    cmp r12, BUF_CAPACITY
    jl skip_printing
    call BufferOutput

skip_printing:
    cmp bl, 0
    jne repeat_to_the_end

    call BufferOutput       ;print uncompleted buffer

    pop rbp

    ret
;________________________________________________________________

;       BufferOutput
;Prints one symbol which rdi address to.
;Entry: rdi - address of the symbol
;Destr: rax
;________________________________________________________________
BufferOutput:
    push rcx
    push rsi
    push rdx                ;save regs values
    push rdi

    mov rax, 1              ;write syscall
    mov rsi, buffer         ;rsi - buffer to print
    mov rdx, r12            ;rdx = buf len
    mov rdi, 1              ;stdout
    syscall                 ;printing buffer

    pop rdi
    sub rdi, r12            ;~ mov rdi, buffer
    xor r12, r12            ;r12 - buf size

    pop rdx
    pop rsi
    pop rcx

    ret
;________________________________________________________________

;________________________________________________________________
ParseChar:
    call ChooseRegToParse
;    stosb
    mov [rdi], al
    inc rdi
    inc r12
    inc rsi                 ;skip printing 'c' in "%c"

    ret
;________________________________________________________________

;________________________________________________________________
ParseString:
    push rsi
    push rbx

    call ChooseRegToParse
    mov rsi, rax

print_string:
    mov bl, [rsi]
    cmp bl, 0
    je end_parsing_string

    movsb
    inc r12
    cmp r12, BUF_CAPACITY
    jl skip_output
    call BufferOutput

skip_output:
    jmp print_string

end_parsing_string:
    pop rbx
    pop rsi
    inc rsi                 ;avoid printing 's' in "%s"

    ret

;________________________________________________________________

;       ChooseRegToParse
;Returns by rax value of the unused argument. For this, r10 contains count
;specifiers that was passed.
;Entry: r10 - count of used arguments
;Exit: rax - value of first unused argument
;________________________________________________________________
ChooseRegToParse:
    cmp r10, 0
    jne not_rsi
    mov rax, r13
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

    mov rax, [rbp]
    add rbp, 8

go_ret:
    ret
;________________________________________________________________
PrintDebugLine:
    push rdi
    push rsi
    push rdx
    push rcx

    mov rax, 1              ;write syscall
    mov rsi, debug_line     ;rsi - buffer to print
    mov rdx, 5              ;rdx = buf len
    mov rdi, 1              ;stdout
    syscall                 ;printing buffer

    pop rcx
    pop rdx
    pop rsi
    pop rdi
    ret

;________________________________________________________________

section .data
    reg_val     db 0, NEW_LINE

    BUF_CAPACITY equ 01h
    buf_size    db 0
    buffer      db BUF_CAPACITY dup(0)

    NEW_LINE    equ 0Ah
    SPACE       equ 20h

    debug_line  db "BITCH"

section .note.GNU-stack noalloc noexec nowrite progbits
