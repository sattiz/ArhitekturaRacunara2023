    .section .text
.global  main
main:
    mov    $4,%eax
    mov    $1,%ebx
    mov    $msg,%ecx
    mov    $len,%edx
    int    $0x80

    xorl %eax, %eax
    retl

    .section .data
msg:
    .ascii "Hello, World!\n"
    len = . - msg
