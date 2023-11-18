.section .data

n: .long 10101010
f: .long 1
overflow: .byte 0

.section .text
    .globl _start


_start:
    movl %esp, %ebp
    movl $1, %eax
    movl $1, %ebx
fib:
    cmpl $2, n
    jle exit
    addl %eax, %ebx
    jc set_OF
    xchgl %eax, %ebx
    decl n
    jmp fib
set_OF:
    incb overflow
exit:
    movl %eax, f
    movl $1, %eax
    movl $0, %ebx
    int $0x80
