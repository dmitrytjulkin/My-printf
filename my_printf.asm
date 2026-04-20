section .text

global MyPrintf

;// TODO:
;// Times instead of dup
;// Rewrite parsing hex to convinient for oct
;// Write ParseDec

MyPrintf:
    push rbp
    mov rbp, rsp            ;rbp for addressing to args
    add rbp, 16

;Setting jump table for specifiers
    mov rax, parse_bin
    mov jmp_spec_table[8 * 62h], rax
    mov rax, parse_char
    mov jmp_spec_table[8 * 63h], rax
    mov rax, parse_dec
    mov jmp_spec_table[8 * 64h], rax
    mov rax, parse_oct
    mov jmp_spec_table[8 * 6fh], rax
    mov rax, parse_str
    mov jmp_spec_table[8 * 73h], rax
    mov rax, parse_hex
    mov jmp_spec_table[8 * 78h], rax

    mov r13, rsi            ;to use movsw:
    mov rsi, rdi            ;rsi - sentence
    mov rdi, buffer         ;rdi - buffer
    xor rbx, rbx
    xor r12, r12            ;buffer size
    xor r10, r10            ;specifiers counter
    dec r10

repeat_to_the_end:
    mov bl, [rsi]
    cmp bl, '%'
    jne print_symbol

    inc r10
    inc rsi
    mov bl, [rsi]           ;the next symbol
    jmp [jmp_spec_table + 8 * rbx]

    parse_char:
    call ParseChar
    inc rsi                 ;avoid printing 'c' in "%c"
    jmp break

    parse_str:
    call ParseString
    inc rsi                 ;avoid printing 's' in "%s"
    jmp break

    parse_dec:

    parse_hex:
    mov r11, 8              ;max count of digits
    mov r14, 28             ;the val to shr rbx
    mov r15, 4              ;the val to rol rax
    call ParseNonDec
    inc rsi                 ;avoid printing 'x' in "%x"
    jmp break

    parse_oct:
    mov r11, 11             ;max count of digits
    mov r14, 29             ;the val to shr rbx
    mov r15, 3              ;the val to rol rax
    call ParseNonDec
    jmp break

    parse_bin:
    mov r11, 32             ;max count of digits
    mov r14, 31             ;the val to shr rbx
    mov r15, 1              ;the val to rol rax
    call ParseNonDec
    inc rsi                 ;avoid printing 'b' in "%b"
    jmp break

    print_symbol:
    movsb
    inc r12

    break:
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
;Prints buffer with constant size. Set r12 = 0 and rdi as pointer to buffer.
;Entry: rdi - pointer to last element,
;       r12 - elements count in buffer.
;Destr: rax.
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

;       ParseChar
;Prints symbol to buffer. This symbol is one of printf() arguments.
;Entry: rdi - current pointer to buffer's element,
;       r12 - buffer's size,
;       rsi - pointer to string's (1st printf arg) element,
;       r10 - count of passed arguments.
;Exit: rdi, r12.
;Destr: rax.
;________________________________________________________________
ParseChar:
    call ChooseRegToParse

    stosb
    inc r12

    ret
;________________________________________________________________

;       ParseString
;Prints string to buffer. This string is one of printf () arguments
;(not first).
;Entry: r10 - number of passed arguments,
;       rdi - current pointer to buffer's element,
;       r12 - buffer's size.
;Exit: rdi, r12.
;Destr: rax
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
    jl skip_output_str
    call BufferOutput
    skip_output_str:

    jmp print_string

    end_parsing_string:
    pop rbx
    pop rsi

    ret
;________________________________________________________________

;       ParseNonDec
;Prints binary or hexagon number to buffer. This number is one of printf()
;arguments (not first).
;Entry: r10 - number of passed arguments,
;       rdi - current pointer to buffer's element,
;       rsi - pointer to string's (1st printf arg) element,
;       r12 - buffer's size.
;Exit: rdi, r12.
;Destr: rax
;________________________________________________________________
ParseNonDec:
    push rbx
    push rcx

    call ChooseRegToParse
    xor rbx, rbx
    mov rcx, r11
    mov rdx, 4

build_non_dec:
    mov ebx, eax

    push rcx
    mov rcx, r14
    shr ebx, cl                 ;leave the first symbol
    mov rcx, r15
    rol eax, cl                 ;put second symb on the first place
    pop rcx

    cmp ebx, 9
    ja parse_letter
    parse_digit:
    add ebx, '0'
    jmp next
    parse_letter:
    add ebx, 'A' - 0Ah
    next:

    mov [rdi], ebx            ;put symbol in buffer
    inc rdi
    inc r12
    cmp r12, BUF_CAPACITY
    jl skip_output_hex
    push rax
    call BufferOutput       ;choose to print buffer or not
    pop rax
    skip_output_hex:

    loop build_non_dec

    pop rcx
    pop rbx

    ret

;________________________________________________________________

;       ChooseRegToParse
;Returns by rax value of the unused argument. For this, r10 contains count
;specifiers that was passed.
;Entry: r10 - count of used arguments
;Exit: rax - value of first unused argument
;________________________________________________________________
ChooseRegToParse:
    cmp r10, 4
    ja parse_stack_args
    jmp [jmp_arg_table + r10 * 8]

    parse_rsi:
    mov rax, r13
    ret

    parse_rdx:
    mov rax, rdx
    ret

    parse_rcx:
    mov rax, rcx
    ret

    parse_r8:
    mov rax, r8
    ret

    parse_r9:
    mov rax, r9
    ret

    parse_stack_args:
    mov rax, [rbp]
    add rbp, 8
    ret
;________________________________________________________________

;       PrintDebugLine
;Prints const string to stdout to understand if program passing this spot or not
;Destr: rax
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
    jmp_spec_table  dq 128 dup(0)
    jmp_arg_table   dq parse_rsi, parse_rdx, parse_rcx, parse_r8, parse_r9

    BUF_CAPACITY    equ 05h
    buf_size        db 0
    buffer          db BUF_CAPACITY dup(0)

    NEW_LINE        equ 0Ah
    SPACE           equ 20h

    debug_line      db "BITCH"

section .note.GNU-stack noalloc noexec nowrite progbits
