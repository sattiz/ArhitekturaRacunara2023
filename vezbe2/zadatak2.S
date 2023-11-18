.global _start

    .data
first: .long 156
second: .long 2
result: .long 0

    .text
_start:
    movl (first), %ecx
    movl (second), %ebx
    cmp %ecx, %ebx
    jg multiply
    xchg %ecx, %ebx

    multiply:
        xor %eax, %eax
        begin_loop:
            cmp $0, %ecx
            je end_loop
            decl %ecx
            addl %ebx, %eax
            jmp begin_loop
        end_loop:
    movl %eax, result

    movl $1, %eax
    movl $0, %ebx
    int  $0x80

