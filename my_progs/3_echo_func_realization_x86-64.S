.section .data
	format:		.ascii "\n\0"

	SYS_stdout = 1
	SYS_write = 1
	SYS_exit = 60
	stack_step = 8

.section .bss

	argc:	.int
	argv:	.quad

.section .text
	.global _start

_start:

	movq %rsp, %rbp # save pointer to the stack

	movl (%rsp), %eax # save length of the array of arguments
	movl %eax, argc

	addq  $stack_step, %rsp # move to the pointer to ther args array

	movq %rsp, argv # save pointer to the array of arguments to the argc

	movq %rbp, %rsp # align stack to the beginning

	print_arg:
		cmpq $0, (argv) # check if end of argv
		je   exit # go exit else
		movq (argv), %r8 # put the pointer to the string to rax
		movq (%r8), %rax
		call strlen

		# print argument
		mov		%rcx, %rdx			# number of bytes
		mov		(argv), %r8		# address of string to output
		mov		(%r8), %rsi
		mov		$SYS_write, %rax	# system call 1 is write
		mov		$SYS_stdout, %rdi	# file handle 1 is stdout
		syscall

		# print new line
		mov		$format, %rsi		# address of string to output
		mov		$1, %rdx			# number of bytes = 1
		mov		$SYS_write, %rax	# system call 1 is write
		mov		$SYS_stdout, %rdi	# file handle 1 is stdout
		syscall

		add		$8, %rsp			# move to next arg
		jmp		print_arg

	exit:
		mov		$SYS_exit ,%rax
		xor		%rdi, %rdi
		syscall


	# rax >> pointer to the string
	# rcx << length of the string
strlen:
	push %rax

	xor %rcx, %rcx		# nullify counter
	start_loop:
		cmpb	$0, (%rax)	# compare if symbol == '\0'
		je 		end_loop	# end loop
		inc		%rax		# else go to next symbol
		inc		%rcx		# increase counter
		jmp		start_loop
	end_loop:
		pop %rax
		ret



