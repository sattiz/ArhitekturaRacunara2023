.section .data

n: .long 10

.section .text
	.globl _start

_start:
	movl $1, %eax ## fn-1
	movl $1, %ebx ## fn

	movl $2, %ecx ## counter

	fib_loop:
		cmpl n, %ecx ## counter ? n
		je end_fib_loop ## if counter == n then end loop
		addl %ebx, %eax ## fn+1 = fn + fn-1 -> %eax
		xchgl %eax, %ebx ## fn+1 in %eax, fn in %ebx -> so we need to change it to save the logic
		incl %ecx
		jmp fib_loop
	end_fib_loop:

	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
