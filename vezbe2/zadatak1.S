.section .data

    a: .quad 0x123456789ABCDEF0
    b: .quad 0x123456789ABCDEF1

    more = 1
    less = -1
    equal = 0
    sys_exit = 0x01

.section .text
    .globl _start
_start:

    movl a+4, %eax
    cmpl b+4, %eax ## eax - b(first 4 bites) ? 0
    jg a_more_b
    jl a_less_b

    movl a, %eax
    cmpl b, %eax ## eax - b(last 4 bites) ? 0
    jg a_more_b
    jl a_less_b

    movl $equal, %esi
    jmp exit

a_more_b:
    movl $more, %esi
    jmp exit

a_less_b:
    movl $less, %esi
    jmp exit

exit:
    movl $sys_exit, %eax
    xor  %ebx, %ebx
    syscall
