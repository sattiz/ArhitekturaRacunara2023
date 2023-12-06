.section .data

s1: .asciz "qwertaatrewq"
r: .byte 0 ## 1 - it is palindrome, 0 - not palindrome
.section .text
    .globl _start

_start:
    movl %esp, %ebp

    pushl $s1
    call strlen
    popl %ecx

    movl $s1, %eax
    movl $s1, %ebx
    addl %ecx, %ebx
    xor %ecx, %ecx
begin_loop:
    cmpl %eax, %ebx
    jle good_end_loop
    movb (%eax), %cl
    cmpb %cl, (%ebx)
    jne bad_end_loop
    incl %eax
    decl %ebx
    jmp begin_loop

good_end_loop:
    movl $1, r
bad_end_loop:

    movl $1, %eax
    xor %ebx, %ebx
    int $0x80


strlen:
## prologue
    pushl %ebp
    movl %esp, %ebp
    pushl %eax
    pushl %ebx

    movl 8(%ebp), %eax
    xor %ebx, %ebx
begin_strlen_loop:
    cmpl $0, (%eax)
    je end_strlen_loop
    incl %ebx
    incl %eax
    jmp begin_strlen_loop
end_strlen_loop:
    decl %ebx
    movl %ebx, 8(%ebp)
## epilogue
    popl %ebx
    popl %eax
    popl %ebp
    retl
