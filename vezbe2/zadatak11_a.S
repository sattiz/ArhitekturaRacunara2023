.section .data

a:  .quad -1 ##0x10000000
b:  .quad -10 ##0x10
r:  .quad 0
oper_type: .byte 1 ## unsigned == 0 | signed == 1

overflow: .byte 0
neg_res: .byte 1 ## if == -1 result should be negated

.section .text
    .globl _start

_start:
    subl $8, %esp
    movl %esp, %ebp

    cmpb $0, oper_type
    je compare_args

    ## check if a < 0
    check_a:
        cmpl $0, a+4
        jg check_b
        pushl $a ## pass arg1
        call neg_quad ## func call
        movl %ebp, %esp
        negb neg_res ## inv neg_res
    check_b:
    ## check if b < 0
        cmpl $0, b+4
        jg compare_args
        pushl $b ## pass arg2
        call neg_quad ## func call
        movl %ebp, %esp
        negb neg_res ## inv neg_res

    compare_args:
        pushl $b ## arg2
        pushl $a ## arg1
        call compare ## func call
        popl %eax ## get res
        movl %ebp, %esp ## clear stack

        cmpl $0, %eax
        je mult_init
        pushl $b ## pass arg2
        pushl $a ## pass arg1
        call exchage_values ## func call
        movl %ebp, %esp ## clear stack

    mult_init:
        movl b, %eax
        movl b+4, %ebx
    main_multiply:
        cmpl $0, a ## low_bites ? 0
        jne mult_step ## `!=` -> make one step
        cmpl $0, a+4 ## high_bites ? 0
        je check_res ## `==` -> check res > 0

    mult_step:
        addl %eax, r ## low_bites of result += low_bites
        adcl %ebx, r+4 ## high_bites of result += high_bites+CF
        jc set_OF ## if CF=1 -> set `overflow` to 1 then exit
        subl $1, a ## low bited of counter -= 1
        sbbl $0, a+4 ## high_bites of counter -= 0 + СF
        jmp main_multiply

    check_res:
        cmpl $0, r+4
        jl set_OF
        cmpl $1, neg_res
        jne exit
        pushl $r
        call neg_quad
        movl %ebp, %esp
        jmp exit

    set_OF:
        movb $1, overflow
    exit:
        movl $1, %eax
        movl $0, %ebx
        int  $0x80




## >> (long long*)arg1, (long long*)arg2
## << |arg1| >= |arg2| ? 1 : 0
compare:
## prologue
    pushl %ebp # fpb
    movl  %esp, %ebp # fbp+12 == retA | fbp+16 == arg1 | fbp+20 == arg2
    pushl %eax # fbp+8
    pushl %ebx # fbp+4

    movl 16(%esp), %eax # arg1
    movl (%eax), %eax
    movl 20(%esp), %ebx # arg2
    movl (%ebx), %ebx
    cmpl %ebx, %eax
    jl a_less_b

    movl 12(%esp), %eax
    movl 4(%eax), %eax
    movl 16(%esp), %ebx
    movl 4(%ebx), %ebx
    cmpl %ebx, %eax
    jl a_less_b

    movl $1, 16(%esp)
    jmp end

    a_less_b:
    movl $0, 16(%esp)

## epilogue
    end:
    popl %ebx
    popl %eax
    popl %ebp
    ret



## changes valuses by ptr
## >> (long long*)arg1, (long long*)arg2
## << void
exchage_values:
## prologue
    pushl %ebp
    movl %esp, %ebp
    pushl %eax
    pushl %ebx

## change first 4 bytes
    movl 8(%ebp), %eax ## ptr(val1) -> eax:ptr(val1)
    movl (%eax), %eax ## *ptr(val1) -> eax:val1
    movl 12(%ebp), %ebx ## ptr(val2) -> ebx:ptr(val2)
    xchgl %eax, (%ebx) ## eax:val1 <-> *ptr(val2)
    movl 8(%ebp), %ebx ## ptr(val1) -> ebx:ptr(val1)
    movl %eax, (%ebx) ## eax:value2 -> *ptr(val1)

## change second 4 bytes
    movl 8(%ebp), %eax ## ptr(val1) -> eax
    movl 4(%eax), %eax ## *ptr(val1)+4 -> eax
    movl 12(%ebp), %ebx ## ptr(val2) -> ebx
    xchgl %eax, 4(%ebx) ## eax:val1 <-> *ptr(val2)+4
    movl 8(%ebp), %ebx ## ptr(val1) -> ebx
    movl %eax, 4(%ebx) ## eax:value2 -> *ptr(val1)+4

## epilogue
    popl %ebx
    popl %eax
    popl %ebp
    ret



## make *arg1 negative
## >> (long long*)arg1
## << void
neg_quad:
## prologue
    pushl %esp
    movl %esp, %ebp
    pushl %eax

    movl 8(%ebp), %eax
    notl 4(%eax) ## make a > 0
    negl (%eax)

## epilogue
    popl %eax
    popl %esp
    ret
