# 3. На языке ассемблера реализовать умножение двух чисел с помощью сложения,использование
# переменных двойной точности
# а. Основная идея идентична предыдущей задаче.
# б. Разница: следует использовать 64-битные переменные.
# в. Используйте пример сложения двойной точности, приведенный на слайдах из второго семестра
# упражнений; проверьте наличие ошибки переполнения


.section .data

a:  .quad 0x10000000
b:  .quad 0x10
r:  .quad 0
overflow: .long 0

.section .text
    .globl _start

_start:
    movl %esp, %ebp

    pushl $b  # arg2
    pushl $a  # arg1
    call compare
    popl %eax
    movl %ebp, %esp

    cmpl $0, %eax
    je mult_init
    pushl $b
    pushl $a
    call exchage_values
    movl %ebp, %esp

mult_init:
    movl b, %eax
    movl b+4, %ebx
main_multiply:
    cmpl $0, a ## low_bites ? 0
    jne mult_step ## `!=` -> make one step
    cmpl $0, a+4 ## high_bites ? 0
    je exit ## `==` -> exit program

mult_step:
    addl %eax, r ## low_bites of result += low_bites
    adcl %ebx, r+4 ## high_bites of result += high_bites+CF
    jc set_OF ## if CF=1 -> set `overflow` to 1 then exit
    subl $1, a ## low bited of counter -= 1
    sbbl $0, a+4 ## high_bites of counter -= 0 + СF
    jmp main_multiply

set_OF:
    movl $1, overflow
exit:
    movl $1, %eax
    movl $0, %ebx
    int  $0x80


## >> (long long*)arg1, (long long*)arg2
## << arg1 >= arg2 ? 1 : 0
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

