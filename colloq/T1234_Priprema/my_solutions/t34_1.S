    inv_masq = 0b10
    check_masq = 0b1
    arr_step = 4

.section .text
    .globl BitSwitch

BitSwitch:
## prologue
    pushl %ebp ## init stack frame of the function
    movl %esp, %ebp
    pushl %esi ## save registers condition
    pushl %edi
    pushl %ebx
    pushl %ecx

    ## init section
    xorl %eax, %eax  ## nullify res reg (%eax)
    movl 8(%ebp), %esi ## load ptr of the arr
    movl 12(%ebp), %ebx ## load arrlen

    BitSwitch_main_loop:
        cmpl $0, %ebx ## check if end of arr
        je BitSwitch_main_loop_end
        ## save condition of the register, we need free regs for further loop
        pushl %ebx
        pushl %esi

        ## init regs for qurrent elem of arr
        movl (%esi), %esi ## value of elem
        xorl %ebx, %ebx ## nullify counter
        movl $inv_masq, %ecx ## load reverse masq into ecx
        movl $check_masq, %edi ## load check masq into edi
        BitSwitch_invert_number_loop:
            cmpl $31, %ebx ## go throw every bit from 0 to 31
            je BitSwitch_invert_number_loop_end ## if end of number

            testl %edi, %esi ## if current bit is not 0
            je BitSwitch_invert_number_loop_continue ## then skip iteration
            ## if not then
            xorl %ecx, %esi ## invert next bit
            incl %eax ## increase result counter

            BitSwitch_invert_number_loop_continue: ## next step
                shll $1, %ecx ## shift reverse masq
                shll $1, %edi ## shift check masq
                incl %ebx ## next bit
                jmp BitSwitch_invert_number_loop
        BitSwitch_invert_number_loop_end:

        ## return condition of the registers
        popl %esi ## ptr to the elem
        popl %ebx ## counter condition
        ## next step
        decl %ebx ## decrease counter
        addl $arr_step, %esi ## next elem of the array
        jmp BitSwitch_main_loop
    BitSwitch_main_loop_end:

## epilogue
    popl %ecx ## restore condition on the registers
    popl %ebx
    popl %edi
    popl %esi
    popl %ebp ## restore stack frame
    ret

