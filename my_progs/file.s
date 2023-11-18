.section .data
hi_message: .asciz "Enter your name, surname:"
        hm_len = . - hi_message

.section .bss
buffer: .space 50
        BUFSIZE = . - buffer

.section .text
    .globl _start

_start:
    movl %esp, %ebp

    ##write(1, hm_len, hi_message)
    movl $4, %eax
    movl $1, %ebx
    movl $hi_message, %ecx
    movl $hm_len, %edx
    int $0x80

    ## read(0, rd_len, buffer)
    movl $3, %eax
    movl $0, %ebx
    movl $buffer, %ecx
    movl $BUFSIZE, %edx
    int $0x80

    ## get buflen
    push $buffer
    call strlen
    popl %edx
    movl %ebp, %esp

    ## write(1, buflen, buffer)
    movl $4, %eax
    movl $1, %ebx
    movl $buffer, %ecx
    int $0x80

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

## >> arg1 = ptr(str)
## << len(str)
strlen:
## prolog
    pushl %esp
    movl %esp, %ebp
    pushl %eax
    pushl %ecx

    xor %ecx, %ecx
    movl 8(%ebp), %eax
strlen_loop:
    cmpl $0, (%eax)
    je strlen_endloop
    incl %ecx
    incl %eax
    jmp strlen_loop
strlen_endloop:

    movl %ecx, 8(%esp)
## epilogue
    popl %ecx
    popl %eax
    popl %ebp
    ret
