#include <sys/syscall.h>

.section .data
	message:	.ascii "Hello!\0"
	format:		.ascii "\n\0"
	SYS_stdout = 1
	EXIT_SUCCESS = 0

.section .text

	.global _start

_start:

	mov		%rsp, %rbp		# save base pointer of the stack
	mov		(%rsp), %rcx	# get and save amount of args (path/to/program and all args)
	add		$8, %rsp		# skip file name and move pointer to first argv

	print_arg:
		cmpq	$0, (%rsp)	# check if end of argv
		je		exit 		# go exit else
		strlen:				# get string len
			xor %rcx, %rcx		# nullify counter
			mov (%rsp), %rax	# put the pointer to the string to rax
			start_loop:
				cmpb	$0, (%rax)	# compare if symbol == '\0'
				je 		end_loop	# end loop
				inc		%rax		# else go to next symbol
				inc		%rcx		# increase counter
				jmp		start_loop
			end_loop:

		# print argument
		mov		%rcx, %rdx			# number of bytes
		mov		(%rsp), %rsi		# address of string to output
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
		mov		$EXIT_SUCCESS, %rbx	# return code
		mov		$SYS_exit ,%rax		# syscall number
		syscall
