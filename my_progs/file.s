.section .data
   # Пример переменной в памяти, инициализированной значением 0
	argc:	.int 0
	argv:	.quad 0

	Stack_step = 8

.section .text
	.globl _start

_start:

	movq %rsp, %rbp
	movl (%rsp), %eax
	movl %eax, argc
	add  $Stack_step, %rsp
	movq %rsp, argv
	movq %rbp, %rsp

    # # Завершение программы
    mov $60, %rax           # Код системного вызова для exit
    xor %rdi, %rdi          # Код возврата 0
    syscall


strlen:
	push %rax

	xor %rcx, %rcx		# nullify counter
	start_loop:
		cmpb	$0, (%rax)	# compare if symbol == '\0'
		je 		end_loop	# end loop
		inc		%rax		# else go to next symbol
		inc		%rcx		# increase counter
		jmp		start_loop
	end_loop: ret
