.section .data

arr: .long 0, 1, 2, 3, 4, 5, 6, 7, 8
len: .long 9

.section .text

.globl _start
    movl %esp, %ebp

    push len
    push $arr
    call InvertBits
    movl %ebp, %esp

    movl $1, %eax
    movl $0, %ebx
    int $0x80
_start:

InvertBits:
	pushl %ebp
	movl %esp, %ebp
	
	# sacuvaj registre (engl. save old registers' values)
	pushl %ebx 
	pushl %esi
	
	movl $1, %edx # maska (engl. mask)
	movl $0, %ebx # brojac za petlju (engl. counter for the loop)
	movl 8(%ebp), %esi # adresa početka niza sa indeksima u esi (engl. address of the beginning of the array of index in esi)
	movl $0, %eax # pocetna vrednost povratnog podatka je 0 (engl. move 0 to the return value)
	
petlja:
	cmpl %ebx, 12(%ebp) # uporedi brojac sa n, za proveru kraja (engl. compare counter and n, to end the loop if necessary)
	jbe kraj
	
	movl (%esi), %ecx # trenutni element niza u ecx (engl. move current element from the array to ecx)
			  # ecx izabran namerno, zbog siftovanja (engl. ecx chosen on purpose, for the sake of shifting)
	
	shll %cl, %edx # siftovati jedinicu u masci na poziciju na koju ukazuje trenutni element niza
		       # engl. shift the 1 in the mask to the position indicated by the current element of the array
	
	xorl %edx, %eax # smestiti jedinicu na mesto na koje ukazuje maska, xor-ovanjem maske sa registrom eax
			# engl. set the bit indicated by the mask to 1; use tha mask to xor the register eax, that is, the return value
	
	incl %ebx # povecaj brojac (engl. increase tha counter)
	addl $4, %esi # predji na sledeci element (engl. move to the next element
	
	movl $1, %edx # resetuj masku, jer se uvek iznova siftuje (engl. reset the mask, since it is always shifted from the beginning)
	
	jmp petlja
	
kraj:
	# restore old registers' values
	popl %esi
	popl %ebx
	
	
	movl %ebp, %esp
	popl %ebp
	ret
