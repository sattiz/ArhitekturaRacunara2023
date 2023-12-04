.section .data
ulaz_str: .ascii "Unesite string: \0"
    hi_len = . - ulaz_str
izlaz_str: .ascii "Rezultujuci string: \0"
    bye_len = . - izlaz_str

    buflen = 50
buffer: .space buflen
strlen: .long 0
    low_up_diff = 32

.macro print_str str_ptr, len
    movl $4, %eax
    movl $1, %ebx
    movl \str_ptr, %ecx
    movl \len, %edx
    int  $0x80
.endm

.macro read_str str_ptr, len
    movl $3, %eax
    movl $0, %ebx
    movl \str_ptr, %ecx
    movl \len, %edx
    int  $0x80
.endm

.section .text
    .globl _start

_start:
    movl %esp, %ebp

    print_str $ulaz_str, $hi_len ## print hi
    read_str $buffer, $buflen ## read input
    movl %eax, strlen ## get input string length

    movl $buffer, %esi ## set ptr for going throw string
    xorl %ecx, %ecx ## setup counter
    xorl %edx, %edx ## setup fullstop flag
    loop:
        cmpl %ecx, strlen ## if string end then endloop
        je endloop

        pushl %esi ## check if symbol is lowercase or fullstop
        call check_symb
        popl %eax
        movl %ebp, %esp

        cmpl $0, %eax ## is_not then continue
        je continue

        cmpl $2, %eax ## is_fs then set up flag
        jne inloop_check_lower_case
        movl $1, %edx
        jmp continue

        inloop_check_lower_case:
        ## else if lowercase
        cmpl $1, %edx ## check flag
        jne continue ## if flag == zero then continue
        ## else if flag == 1, then make uppercase
        subl $low_up_diff, (%esi)
        movl $0, %edx ## unset flag

    continue: ## go to next symbol
        incl %esi
        incl %ecx
        jmp loop
    endloop:

    print_str $izlaz_str, $bye_len
    print_str $buffer, strlen

    movl $1, %eax
    movl $0, %ecx
    int  $0x80


## >> (char*)arg1
## << 1 if lowercase letter, 2 if fullstop, 0 if neither
check_symb:
## prologue
    pushl %ebp
    movl %esp, %ebp
    pushl %eax

    movl 8(%ebp), %eax
    movb (%eax), %al

    cmp $'.', %al
    je is_fs

    cmp $'a', %al
    je is_lowercase
    jl is_not

    cmp $'z', %al
    je is_lowercase
    jg is_not

    jmp is_lowercase
is_fs:
    movl $2, 8(%ebp)
    jmp epilogue
is_lowercase:
    movl $1, 8(%ebp)
    jmp epilogue
is_not:
    movl $0, 8(%ebp)
epilogue:
    popl %eax
    popl %ebp
    retl
