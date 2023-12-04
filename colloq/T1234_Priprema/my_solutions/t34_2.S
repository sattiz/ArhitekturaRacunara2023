.section .text

.globl InvertBits

InvertBits:
## prologue
    pushl %ebp ## init stack frame of function
    movl %esp, %ebp
    pushl %edi ## save regs condition
    pushl %esi
    pushl %ebx
    pushl %ecx

    movl 8(%ebp), %esi ## get ptr to first elem of the array
    movl 12(%ebp), %ebx ## get len
    movl $0, %eax ## nullify value of `res`

    InvertBits_invert_bit_loop:
        cmp $0, %ebx ## if end of arr, then exit
        je InvertBits_invert_bit_loop_end
        ## else, then loop step
        movl (%esi), %ecx ## get value of element of array
        movl $1, %edi ## init masq
        shll %cl, %edi ## create masq
        orl %edi, %eax ## set bit of result

        ## next step
        addl $4, %esi ## next elem of the arr
        decl %ebx ## decl counter
        jmp InvertBits_invert_bit_loop
    InvertBits_invert_bit_loop_end:

    ## restore condition of the regs
    popl %ecx
    popl %ebx
    popl %esi
    popl %edi
    popl %ebp ## restore stackframe
    retl
