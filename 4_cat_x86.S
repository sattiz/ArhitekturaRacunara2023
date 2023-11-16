.section .data

	# FD for input, maybe a file but in default stdin
	fdin:	.long 0
	# FD for output, maybe a file but in default stdout
	fdout:	.long 1

	str_erropenfdin:	.string "Error open in-file\n"
	str_erropenfdinlen = . - str_erropenfdin - 1

	str_erropenfdout:		.string "Error open out-file\n"
	str_erropenfdoutlen = . - str_erropenfdout - 1
	
	str_errreadfdin:	.string "Error reading in-file\n"
	str_errreadfdinlen = . - str_errreadfdin - 1

	str_errwritefdout:		.string "Error writing out-file\n"
	str_errwritefdoutlen = . - str_errwritefdout - 1



.section .bss
	# a buffer for reading from fdin and writing to fdout
	.equ BUFFER_SIZE, 8192
	.lcomm buffer, BUFFER_SIZE


.section .text
	.globl _start



_start:
	# remember the stack pointer, so we can access
	# argc and argv independent of stack operations
	movl	%esp, %ebp


	# check if in-filename is given in argv
	movl	(%ebp), %ebx
	cmpl	$1, %ebx
	je		fdin_ready

	# open file to read, O_RDONLY
	movl	$5, %eax
	movl	8(%ebp), %ebx
	movl	$0, %ecx
	movl	$0666, %edx
	int		$0x80

	# test if fd from opening was successful
	movl	%eax, fdin
	cmpl	$0, %eax
	jl		error_openfdin


fdin_ready:

	# check if out-filename is given in argv
	movl	(%ebp), %ebx
	cmpl	$3, %ebx
	jl		fdout_ready

	# open file to write, O_RDONLY | O_CREAT
	movl	$5, %eax
	movl	12(%ebp), %ebx
	movl	$0x41, %ecx
	movl	$0777, %edx
	int		$0x80

	# test if fd from opening was successful
	movl	%eax, fdout
	cmpl	$0, %eax
	jl		error_openfdout



fdout_ready:

	# from now on we can read write a bulk of data

	read_loop:

	#Read up to BUFFER_SIZE many bytes to buffer
	movl	$3, %eax
	movl	fdin, %ebx
	movl	$buffer, %ecx
	movl	$BUFFER_SIZE, %edx
	int		$0x80

	# if EOF, exit
	cmpl	$0, %eax
	je		exit
	jl		error_readfdin


	#Write bulk of data to fdout
	movl	%eax, %edx
	movl	$4, %eax
	movl	fdout, %ebx
	movl	$buffer, %ecx
	int		$0x80

	# if error, exit
	cmpl	$0, %eax
	jl		error_writefdout

	#And again
	jmp read_loop


exit:
	# exit, exit status in eax
	movl	%eax, %ebx
	movl	$1, %eax
	int		$0x80

	

error_openfdin:
	movl	$str_erropenfdin, %ecx
	movl	$str_erropenfdinlen, %edx
	jmp		print_error

error_openfdout:
	movl	$str_erropenfdout, %ecx
	movl	$str_erropenfdoutlen, %edx	
	jmp		print_error

error_readfdin:
	movl	$str_errreadfdin, %ecx
	movl	$str_errreadfdinlen, %edx
	jmp		print_error

error_writefdout:
	movl	$str_errwritefdout, %ecx
	movl	$str_errwritefdoutlen, %edx
	jmp		print_error


print_error:
	# print message
	pushl	%eax
	movl	$4, %eax
	movl	$2, %ebx
	jmp 	exit

	# exit with error code from eax
	popl	%eax
	jmp		exit









