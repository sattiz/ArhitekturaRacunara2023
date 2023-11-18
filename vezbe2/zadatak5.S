.section .data

n: .long 60
f: .quad 1
overflow: .byte 0

.section .text
    .globl _start

_start:
    movl $1, %eax
    movl $1, %ebx
    movl $0, %ecx
    movl $0, %edx

fib:
    cmpl $2, n
    je exit
    addl %eax, %ebx
    adcl %ecx, %edx
    jc set_OF
    xchgl %eax, %ebx
    xchgl %ecx, %edx
    decl n
    jmp fib
set_OF:
    incb overflow
exit:
    movl %eax, f
    movl %ecx, f+4
    movl $1, %eax
    movl $0, %ebx
    int  $0x80
