#autor: Vladimir Morozkon SV85/2023

.section .data
ulaz_str: .ascii "Unesite string: \0"
ulazLen = .-ulaz_str
izlaz_str: .ascii "Rezultujuci string: \0"
izlazLen = .-izlaz_str
stroka: .space 50


.section .text
.global main
main:
	##syscall stdout
	movl $4, %eax
	movl $1, %ebx
	leal ulaz_str, %ecx
	movl $ulazLen, %edx
	int $0x80

	## syscall stdin
	movl $3, %eax
	movl $0, %ebx
	leal stroka, %ecx
	movl $50, %edx
	int $0x80

	## save len stdin in esi and edi
	movl %eax, %esi
	movl %eax, %edi
	leal stroka, %eax

findPoint:
	## check end of sting
	cmpl $0, %esi
	je krajString

	movb (%eax), %cl

	##is '.' in cl?
	cmpb $'.', %cl
	je findFirstLowCase
	jmp findPoint_step

findPoint_step:
	## go to next
	decl %esi
	incl %eax
	jmp findPoint


##findPoint_end

findFirstLowCase:
	cmpl $0, %esi
	je krajString

	movb (%eax), %cl

	cmpb $'a', %cl
	jl findFirstLowCase_step
	cmpb $'z', %cl
	jg findFirstLowCase_step

	subb $32, (%eax) ## tut vopros, vicitaem iz cl ili iz eax
	jmp findPoint_step

findFirstLowCase_step:
	decl %esi
	incl %eax
	jmp findFirstLowCase


##findFirstLowCase_end

krajString:

	##syscall stdout string
	movl $4, %eax
	movl $1, %ebx
	leal izlaz_str, %ecx
	movl $izlazLen, %edx
	int $0x80

	##syscall stdout string changed
	movl $4, %eax
	movl $1, %ebx
	leal stroka, %ecx
	movl %edi, %edx
	int $0x80

kraj:
	movl $1, %eax
	xor %ebx, %ebx
	int $0x80
