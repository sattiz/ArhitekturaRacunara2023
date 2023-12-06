
.section .data

    Sys_exit = 0x01

    n = 5

.section .text
    .globl _start

_start:

    # put n to the conter register (ecx)
    mov $n, %ecx
    # nullify accumulator (eax)
    xor %eax, %eax

    loop:
        cmp $0, %ecx # if counter == 0
        je loop_end # then go to end_loop
        ## else counting result in accumulator (eax)
        addl %ecx, %eax # add n to the res
        decl %ecx # n -= 1
        jmp loop
    loop_end:

    # exit program
    mov $Sys_exit, %eax
    xor  %esi, %esi
    syscall
