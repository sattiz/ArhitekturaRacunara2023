.section .data
    a = 27
    b = 10

    first = %eax
    second = %ebx

    multiplyer = %ebx
    counter = %ecx

    acc = %eax

    sys_exit = 0x01
.section .text
    .globl _start

_start:

    movl $a, first
    movl $b, second
    xor  counter, counter

    ## if second - first > 0 -> second > first:
            # counter = first, multiplyer = second
    ## else if second - first < 0 -> second < first:
            # counter = second, multiplyer = first
    cmp first, second
    jg put_first_counter

    put_second_counter:
        movl second, counter
        movl first , multiplyer
        jmp multiply
    put_first_counter:
        movl first, counter
        movl second, multiplyer


    multiply:
        xor acc, acc ## nulify res accumulator
        begin_loop:
            cmp $0, counter  # counter == 0?
            je end_loop # end loop
            add multiplyer, acc # acc += multiplyer
            sub $1, counter # counter -= 1
            jmp begin_loop # go to begin_loop
        end_loop:

    movl $sys_exit, %eax
    xor %esi, %esi
    syscall

