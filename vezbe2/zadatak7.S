.section .data

a: .int 30
b: .int 18
res: .int 0


.section .text
    .globl _start

_start:
    movl a, %eax
    movl b, %ebx
    xor %ecx, %ecx
euclid:
    cmpl %ebx, %eax
    jl swap
    subl %ebx, %eax
    incl %ecx
    jmp euclid
swap:
    cmpl $0, %eax
    je exit
    xchgl %eax, %ebx
    xor %ecx, %ecx
    jmp euclid
exit:
    movl %ebx, res
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
