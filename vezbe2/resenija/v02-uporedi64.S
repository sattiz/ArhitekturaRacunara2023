# Poređenje dva broja u dvostrukoj preciznosti
# Imenko Prezimić ra1234

.section .data

a: .quad 0x123456789ABCDEF0
b: .quad 0x123456789ABCDEF1

.section .text
.globl _start

_start:
    movl a+4, %edx  # poredimo više delove
    cmpl b+4, %edx
    jg a_vece
    jl b_vece

    movl a, %edx    #poredimo niže delove
    cmpl b, %edx
    ja a_vece
    jb b_vece

    movl $0, %eax   # a = b
    jmp kraj

a_vece:
    movl $1, %eax
    jmp kraj

b_vece:
    movl $-1, %eax

kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
    
