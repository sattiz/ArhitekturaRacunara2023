.section .data
ulaz_str: .ascii "Unesite string: \0"
unos_max = 50
unos: .fill unos_max, 1, 42
len_ulaz_str: .long 17
min: .byte 0
max: .byte 0

.section .text

.globl main

main:

    ## Ask user to type some string

    movl $4, %eax
    movl $1, %ebx
    movl $ulaz_str, %ecx
    movl len_ulaz_str, %edx
    int $0x80

    ## Read what user has types

    movl $3, %eax
    movl $0, %ebx
    movl $unos, %ecx
    movl unos_max, %edx
    int $0x80

    ## Move length of input to %esi and put the adress to the first elem of the input string to %ebx

    movl %eax, %esi
    movl $unos, %ebx
    xorl %eax, %eax ## nullify %eax

    find_num_loop:

        cmpl $0, %esi
        je exit

        movb (%ebx), %cl

        cmpb $'0', %cl
        jl find_num_step

        cmpb $'9', %cl
        jg find_num_step

        jmp find_min_max_endloop

    find_num_step:

        decl %esi
        incl %ebx
        jmp find_num_loop

    find_min_max_endloop:

        movb %cl, min
        movb %cl, max
        jmp find_min_max_loop

    find_min_max_loop:

        cmpl $0, %esi
        je exit

        cmpb $'0', %cl
        jl find_num_step

        cmpb $'9', %cl
        jg find_num_step

        cmpb min, %cl
        je update_min

        cmpb max, %cl
        jg update_max

        jmp find_min_max_step

        update_min:

        movb %cl, min
        jmp find_min_max_step

        update_max:

        movb %cl, max
        jmp find_min_max_step


    find_min_max_step:

        decl %esi
        incl %ebx
        movb (%ebx), %cl

exit:

    xor %ebx, %ebx
    movb min, %bl
    addb max, %bl

    movl $1, %eax
    int $0x80
