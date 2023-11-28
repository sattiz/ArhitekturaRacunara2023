.section .data
ulaz_str: .ascii "Unesite string: \0"
    ulaz_len = . - ulaz_str
unos_max = 50
unos: 	.fill unos_max,1,42

min: .long 0
max: .long 0
input_len: .long 0

.section .text
    .globl main

main:

    subl $8, %esp
    movl %esp, %ebp

    ## say hi message
    movl $4, %eax
    movl $1, %ebx
    movl $ulaz_str, %ecx
    movl $ulaz_len, %edx
    int  $0x80

    ## get input string
    movl $3, %eax
    movl $0, %ebx
    movl $unos, %ecx
    movl $ulaz_len, %edx
    int  $0x80

    ## get input length, set counter, set input ptr
    movl %eax, input_len
    xor %ecx, %ecx
    movl $unos, %esi

    ## loop to find first digit in string
    find_first_digit_loop:
        cmpl input_len, %ecx ## if end of string then there is no digits
        je nodigits_str_exit

        pushl %esi ## check if it is digit
        call check_if_digit
        popl %eax
        movl %ebp, %esp

        cmpl $1, %eax ## if found symbol is not digit then move to the next symbol
        je find_first_digit_loop_end

        incl %esi ## to next symbol
        incl %ecx ## inc counter
        jmp find_first_digit_loop

    find_first_digit_loop_end: ## else then we found first digit -> end loop

    ## set min and max as found symbol
    movl (%esi), %edx
    movl %edx, min
    movl %edx, max
    incl %esi ## continue checks from the next symbol
    incl %ecx
    xor %eax, %eax

    ## check other symbols of the string
    find_min_max_loop:
        cmpl input_len, %ecx
        je find_min_max_loop_end

        pushl %esi ## check if it is digit
        call check_if_digit
        popl %eax
        movl %ebp, %esp

        cmpl $1, %eax ## if found symbol is not digit then move to the next symbol
        jne continue

        ## if symbol is digit put symbol into reg
        movb (%esi), %al

        ## check if min > %eax(digit)
        cmpl min, %eax
        jge skip_min_assignment
        movl %eax, min
        skip_min_assignment:

        ## check if max < %eax(digit)
        cmpl max, %eax
        jle skip_max_assignment
        movl %eax, max
        skip_max_assignment:

        continue:
            incl %ecx
            incl %esi
            xor %eax, %eax
            jmp find_min_max_loop
    find_min_max_loop_end:

    xorl %ebx, %ebx
    movb min, %bl
    addb max, %bl
    jmp exit_call

nodigits_str_exit:
    movl $0, %ebx
    jmp exit_call

exit_call:
    movl $1, %eax
    int  $0x80




## arg1(word) >> symb
## << 0 is_not_digit | 1 is_digit
check_if_digit:
## prolog
    pushl %ebp
    movl %esp, %ebp
    pushl %eax

## func body
    movl 8(%ebp), %eax ## get ptr(arg1)
    movb (%eax), %al ## get *ptr(arg1)

    cmpb $'0', %al
    je is_digit
    jl is_not_digit
    cmpb $'9', %al
    je is_digit
    jg is_not_digit
is_digit:
    movl $1, 8(%ebp)
    jmp exit_check_if_digit
is_not_digit:
    movl $0, 8(%ebp)
exit_check_if_digit:

## epilogue
    popl %eax
    popl %ebp
    ret
