.section .data

    n = 5

    sys_exit=0x01
.section .text
    .globl _start

_start:

    movl %esp, %ebp
    movl $n, %eax
    movl $n, %ecx

    begin_fact:
        sub $1, %ecx
        cmp $1, %ecx
        je end_fact
        movl %ecx, %ebx
        call multiply
        jmp begin_fact
    end_fact:

    # exit
    movl $sys_exit, %eax
    xor %esi, %esi
    syscall


    ## >> input:
    ## %eax - first
    ## %ebx - second
    ## >> output
    ## %eax - result
multiply:
    pushl %ebx
    pushl %ecx

    ## if second - first > 0 -> `second > first` -> `first < second`:
            # counter = first, multiplyer = second
    ## else if second - first < 0 -> second < first -> first > second:
            # counter = second, multiplyer = first
    cmp %eax, %ebx
    jl put_second_counter

    put_first_counter:
        movl %eax, %ecx
        jmp start_mult
    put_second_counter:
        movl %ebx, %ecx
        movl %eax, %ebx

    start_mult:
        xor %eax, %eax # nulify res accumulator
        begin_multipl:
            cmp $0, %ecx  # counter == 0?
            je end_multipl # end loop
            add %ebx, %eax # acc += multiplayer
            sub $1, %ecx # counter -= 1
            jmp begin_multipl # go to begin_loop
        end_multipl:

    popl %ecx
    popl %ebx
    ret
