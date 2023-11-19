
.section .data
a: .quad 0x1200000000
b: .quad 0x120000000
rem: .quad 0
res: .quad 0
err: .byte 0

.section .text
    .globl _start
_start:
    movl a, %eax
    movl a+4, %ebx
    cmpl $0, b
    jne div
    cmpl $0, b+4
    je div_by_zero
div:
    cmpl b+4, %ebx
    ja dsub
    jl exit
    cmpl b, %eax
    jl exit
dsub:
    subl b, %eax
    sbbl b+4, %ebx
    addl $1, res
    adcl $0, res+4
    jmp div
div_by_zero:
    incb err
exit:
    movl %eax, rem
    movl %ebx, rem+4
    movl $1, %eax
    movl $0, %ebx
    int  $0x80
