.macro print_string src, len
	movl $4, %eax
	movl $1, %ebx
	movl \src, %ecx
	movl \len, %edx
	int $0x80
.endm

.macro apend_number_to_str

.endm

.section .data

buffer: .space 128
len: .long 0

number: .long 1125

orders: .long 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10

border: .ascii "-2147483648\n\0"
		brd_len = . - border

.section .text

	.globl _start

_start:
	movl number, %eax
	movl $orders, %ebx
	movl $buffer, %edi

	cmpl $0x80000000, %eax
	jne continue
	print_string $border, $brd_len
	jmp exit

continue:
	cmpl $0, %eax
	jg init_one_char
	movl $45, (%edi)
	incl %edi
	incl len
	negl %eax

	init_one_char:
		cmpl $10, %eax
		jl end_converting
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
	addl $48, %eax
	movb %al, (%edi)
	incl len
	incl %edi
	movl $10, (%edi)
	incl len

	print_string $buffer, len

exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80


