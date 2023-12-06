# #  На языке ассемблера реализовать деление для двух знаковых чисел с помощью вычитания, сохраняя остаток,
# # использование переменных двойной точности
# # а. Задача идентична задаче 5 из первого семестра занятий; единственное отличие состоит в том, что
# # делитель, делитель, частное и остаток должны помещаться в переменные (отмеченные ячейки
# # памяти), а не в регистры; числа можно помещать в переменные сразу при инициализации (в части
# # кода .section.data), это не обязательно использоватьдвигатьсяинструкция


.section .data
a: .quad 0xffffffffffffff9b
b: .quad 0xfffffffffffffffa
res: .quad 0x0
rem: .quad 0x0
err: .byte 0x0

.section .text
    .globl _start

_start:
    movl %esp, %ebp
    movl $1, %ecx

    ## check if diviser zero or negeative
    push $b
    call check_sign_quad
    popl %ebx
    movl %ebp, %esp

    ## if zero -> error
    cmpl $-1, %ebx
    je error
    ## if diviser is negative then invert
    cmpl $0, %ebx
    je check_a
    push $b
    call inv_quad
    movl %ebp, %esp
    neg %ecx ## inv flag

check_a:
    ## check if divised is zero or negeative
    push $a
    call check_sign_quad
    popl %eax
    movl %ebp, %esp

    ## if divesed is zero -> res = 0, rem = 0 then exit
    cmpl $-1 %eax
    jne divised_not_zero
    movl $0, res
    movl $0, rem
    jmp exit

    ## if both non zero
divised_not_zero:
    ## if divised is negative then invert
    cmpl $0, %eax
    je division
    push $a
    call inv_quad
    movl %ebp, %esp
    neg %ecx ## inv flag


division:
    push $rem
    push $res
    push $b
    push $a
    call div_quad
    movl %ebp, %esp

    ## if ecx == -1 then result should be inverted
    cmpl $-1, %ecx
    jne exit
    push $result
    jmp exit


error:
    incb err
exit:
    movl $1, %eax
    movl $0, %ebx
    int  $0x80

## >> arg1 = ptr(num)
## << ret == 0 if num < 0 | ret == 1 if num > 0 | ret == -1 if num == 0
check_sign_quad:
## prolog
    pushl %ebp
    movl %esp, %ebp
    pushl %eax

    movl 8(%ebp), %eax

    cmpl $0, 4(%eax)
    jl l_zero
    jg g_zero
    cmpl $0, (%eax)
    je e_zero

    g_zero:
        movl $1, 8(%ebp)
        jmp check_num_end
    l_zero:
        movl $0, 8(%ebp)
        je e_zero
        jmp check_num_end
    e_zero:
        movl $-1, 8(%ebp)
## epilogue
    check_num_end:
        popl %eax
        popl %ebp
        ret

## >> arg1 = ptr(num)
## << void || implicit num -> -num;
inv_quad:
## prologue
    pushl %esp
    movl %esp, %ebp
    pushl %eax

    movl 8(%ebp), %eax
    notl 4(%eax) ## make a *= -1
    negl (%eax)

## epilogue
    popl %eax
    popl %esp
    ret

## >> arg1 = ptr(num1) | arg2 = ptr(num2) | arg3 = ptr(res) | arg4 = ptr(rem)
## << void ||| implicit rem, res = num1\num2
div_quad:
## prolog
    pushl %ebp
    movl %esp, %ebp ## fbp
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx ## fbp-16
    pushl %edi ## fbp-20

## create stack var num2
    subl $8, %esp
    movl 12(%ebp), %eax
    movl (%eax), %ebx ## low_order -> esp
    movl %ebx, (%esp)
    movl 4(%eax), %ebx ## high_order -> esp+4
    movl %ebx, 4(%esp)
            ## fbp-28 <-> %esp

## num1 -> eax, ebx
    movl 8(%ebp), %eax
    movl 4(%eax), %ebp
    movl (%eax), %eax

    div_loop:
        cmpl 4(%esp), %ebx
        ja dsub
        jl div_end
        cmpl (%esp), %eax
        jl iv_end
        dsub:
        subl (%esp), %eax
        sbbl 4(%esp), %ebx
        addl $1, %ecx
        adcl $0, %edx
        jmp div_loop
    div_end:

## lrem(eax, ebx) -> ptr(rem)
    movl 20(%eax), %edi
    movl
## lres(ecx, edx) -> ptr(res)
    movl 16(%ebp), %edi
    movl %ecx, (%edi)
    movl %edx, 4(%edi)

## epilogue
    popl %edi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    popl %ebp
    ret
