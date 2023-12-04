.section .data
ulaz_str: .ascii "Unesite string: \0"
    ulaz_len = . - ulaz_str

    unos_max = 50
unos: 	.fill unos_max,1,42


min: .byte 0
max: .byte 0
.section .text
    .globl _start

_start:
    movl %esp, %ebp

    movl $4, %eax
    movl $1, %ebx
    movl $ulaz_str, %ecx
    movl $ulaz_len, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $unos, %ecx
    movl $unos_max, %edx
    int $0x80

    ## loop init
    movl $unos, %esi
    xorl %ebx, %ebx
find_first_num_loop:
    cmpl $0, %eax
    je exit
    cmpb $'0', (%esi)
    jl find_first_num_loop_step
    cmpb $'9', (%esi)
    jg find_first_num_loop_step
    jmp find_first_num_loop_end
find_first_num_loop_step:
    incl %esi
    decl %eax
    movb (%esi), %bl
    jmp find_first_num_loop
find_first_num_loop_end:

    ## init min and max, step to the next symbol
    movb (%esi), %bl
    movb %bl, min
    movb %bl, max
    incl %esi
    decl %eax

find_min_max_loop:
    cmpl $0, %eax
    je exit

    cmpb $'0', %bl
    jl find_min_max_loop_step
    cmpb $'9', %bl
    jg find_min_max_loop_step

    cmpb %bl, min
    jg find_min_max_loop_check_max
    movb %bl, min
    jmp find_min_max_loop_step

    find_min_max_loop_check_max:
        cmpb %bl, max
        jl find_min_max_loop_step
        movb %bl, max

find_min_max_loop_step:
    incl %esi
    decl %eax
    movb (%esi), %bl
    jmp find_min_max_loop
find_min_max_loop_end:

exit:
    movl $1, %eax
    xor %ebx, %ebx
    addb min, %bl
    addb max, %bl
    int $0x80
