.section .data

    divisible = 56
    divisor = 5

    sys_exit = 1
.section .text
    .globl _start

_start:
    movl %esp, %esp
    movl $divisible, %eax
    movl $divisor, %ebx
    xor %ecx, %ecx

    begin_loop:
        cmp %eax, %ebx
        jg end_loop
        add $1, %ecx
        sub %ebx, %eax
        jmp begin_loop
    end_loop:

    movl $sys_exit, %eax
    xor %esi, %esi
    syscall
