.section .data

    n = 6

    f1 = %eax
    f2 = %ebx
    f3 = %edx
    counter = %ecx

    sys_exit = 0x01
.section .text
    .globl _start

_start:
    movl $n, counter
    sub $2, counter
    movl $1, f1
    movl $1, f2
    xor f3, f3

    begin_loop:
        cmp $0, counter
        je end_loop
        sub $1, counter
        movl f1, f3
        addl f2, f3
        movl f2, f1
        movl f3, f2
        jmp begin_loop
    end_loop:

    movl $sys_exit, %eax
    xor %esi, %esi
    syscall
