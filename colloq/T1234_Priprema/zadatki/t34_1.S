.section .data

array: .int 0x0, 0x1, 0x555
arrlen: .word 0x3


.section .text
    .globl _start

_start:
    movl %esp, %ebp

    pushl arrlen
    pushl $array
    call BitSwitch
    movl %ebp, %esp

    movl $1, %eax
    movl $0, %ebx
    int $0x80



BitSwitch:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %ebx

    movl 8(%ebp), %esi             # adresa pocetka niza
    movl 12(%ebp), %ecx            # duzina niza
    xorl %eax, %eax                # ukupni broj invertovanih bita
    testl %ecx, %ecx               # da li je niz prazan
    je kraj_pp
naredni_element:
    movl -4(%esi, %ecx, 4), %edx   # element niza
    movl $0b10, %ebx               # maska za invertovanje
    movl $0b01, %edi               # maska za proveru bita
proveri_bit:
    testl %edi, %edx
    jz sledeci_bit
    xorl %ebx, %edx
    incl %eax
sledeci_bit:
    shll %ebx
    jc azuriraj_vrednost
    shll %edi
    jmp proveri_bit
azuriraj_vrednost:
    movl %edx, -4(%esi, %ecx, 4)
    loopl naredni_element

kraj_pp:
    popl %ebx
    popl %edi
    popl %esi
    movl %ebp, %esp
    popl %ebp
    ret
