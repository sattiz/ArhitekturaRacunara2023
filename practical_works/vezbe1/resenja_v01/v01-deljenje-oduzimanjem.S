# Deljenje pomoću oduzimanja, uz čuvanje ostatka
# Imenko Prezimić ra1234

.section .data
.section .text
.globl _start
_start:
	movl $8, %eax #prvi operand (deljenik), i ostatak
	movl $3, %ebx #drugi operand (delilac)
	movl $0, %ecx #konačan rezultat (količnik)
    
petlja:
	cmpl %ebx, %eax
	jb kraj
	addl $1, %ecx
	subl %ebx, %eax
	jmp petlja
    
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

