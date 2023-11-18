.section .data

a: .quad 0x0000000100000000
b: .quad 0x8000000100000001
res: .quad 0
overflow: .byte 0
oper_type: .byte 1 ## 0 - unsigned | 1 - signed

.section .text
    .globl _start

_start:
    movl a, %eax
    movl a+4, %ebx
    cmpl $0, oper_type
    je unsigned
## signed
    subl b, %eax
    sbbl b+4, %ebx
    jo set_OF
    jmp put_res
unsigned:
    subl b, %eax
    sbbl b+4, %ebx
    jc set_OF
    jo set_OF
    jmp put_res
set_OF:
    movl $1, overflow
    movl $1, %ebx
    jmp exit
put_res:
    movl %eax, res
    movl %ebx, res+4
    xor %ebx, %ebx
exit:
    movl $1, %eax
    int $0x80
