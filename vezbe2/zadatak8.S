.section .data

data: .long 0x10203040

.section .text
    .globl _start

_start:
    movb data, %al
    movb data+1, %ah
    movb data+2, %bl
    movb data+3, %bh

    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
