.section .data

buffer: .space 128
len: .long 0

number: .long 0xfff12fff

orders: .long 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1

.section .text

	.globl _start

_start:
	movl number, %eax
	movl $orders, %ebx
	movl $buffer, %edi

	cmpl $0, %eax
	jg init_one_char
	movl $45, (%edi)
	incl %edi
	incl len
	negl %eax

	init_one_char:
		cmpl $0, %eax
		je end_converting
		xor %ecx, %ecx
		division:
			cmpl (%ebx), %eax
			jl end_division
			subl (%ebx), %eax
			incl %ecx
			jmp division
		end_division:
		addl $48, %ecx
		movb %cl, (%edi)
		incl len
		incl %edi

		addl $4, %ebx
		jmp init_one_char
	end_converting:
	movl $10, (%edi)
	incl len

	movl $4, %eax
	movl $1, %ebx
	movl $buffer, %ecx
	movl len, %edx
	int $0x80

	movl $1, %eax
	movl $0, %ebx
	int $0x80


