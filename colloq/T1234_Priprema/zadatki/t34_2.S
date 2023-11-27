.section .text

.globl InvertBits

InvertBits:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi
    pushl %esi
    pushl %ebx
    pushl %ecx

    movl 8(%ebp), %esi ## get ptr to first elem of the array
    movl 12(%ebp), %ebx ## get len
    movl $0, %eax ## nullify value of `res`

    invert_bit_loop:
        cmp $0, %ebx
        je invert_bit_loop_end

        ## loop step
        movl (%esi), %ecx
        movl $1, %edi
        shll %cl, %edi
        orl %edi, %eax

        ## next step
        addl $4, %esi
        decl %ebx
        jmp invert_bit_loop
    invert_bit_loop_end:

    popl %ecx
    popl %ebx
    popl %esi
    popl %edi
    popl %ebp
    retl
