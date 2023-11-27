.macro print_string src, len
	movl $4, %eax
	movl $1, %ebx
	movl \src, %ecx
	movl \len, %edx
	int $0x80
.endm

.macro append_symbol symb, dest, len
    push \dest
    addl \len, \dest
    movb \symb, (\dest)
    incl \len
    pop \dest
.endm

.section .data

buffer: .space 128
len: .long 0

number: .long -1125

orders: .long 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10

border: .ascii "-2147483648\n\0"
		brd_len = . - border

.section .text

	.globl _start

_start:
	movl number, %eax
	movl $orders, %ebx
	movl $buffer, %edi

## check if border value
	cmpl $0x80000000, %eax
	jne continue
	print_string $border, $brd_len
	jmp exit

continue:
	cmpl $0, %eax
	jg convert_loop
	append_symbol $'-', %edi, len
	negl %eax

	convert_loop:
		cmpl $10, %eax
		jl end_converting
		movb $'0', %cl
		division:
			cmpl (%ebx), %eax
			jl end_division
			subl (%ebx), %eax
			incb %cl
			jmp division
		end_division:
		append_symbol %cl, %edi, len

		addl $4, %ebx
		jmp convert_loop
	end_converting:
	addl $'0', %eax
	append_symbol %al, %edi, len
	append_symbol $'\n', %edi, len

	print_string $buffer, len

exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80


