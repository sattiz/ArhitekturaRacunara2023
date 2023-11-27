#autor: Imenko Prezimić INDEX ra1234-2015

.section .data
ulaz_str: .ascii "Unesite string: \0"
ulaz_str_len = . - ulaz_str
izlaz_str: .ascii "Rezultujuci string: \0"
izlaz_str_len = . - izlaz_str
unos_max = 50
unos: .fill unos_max, 1, 42
pronasao_tacku: .byte 0 # promenljiva koja oznacava da li se naislo na tacku (engl. a variable to indicate if the full stop was encountered)
.section .text
.globl main
main:
	
	# ispisivanje prve poruke (engl. write the first message to standard output)
	movl $4, %eax
	movl $1, %ebx	
	leal ulaz_str, %ecx
	movl $ulaz_str_len, %edx
	int $0x80

	# unos stringa (engl. enter the string from standard input)
	movl $3, %eax
	movl $0, %ebx	
	leal unos, %ecx
	movl $unos_max, %edx
	int $0x80
	movl %eax, %edi # sacuvaj duzinu unetog stringa u %edi (engl. save the inserted string's length in %edi)

	xorl %esi, %esi 	# esi je indeksni registar (engl. esi is the index register)
	
prolazak:
	cmpb $10, unos(, %esi, 1) # provera kraja stringa (engl. check if it is the end of the string)
	je kraj_stringa
	
	movb unos(,%esi,1), %al # prebacivanje trenutnog karaktera u %al (engl. move the current character to %al)
	cmpb $1, pronasao_tacku  # proveri da li se naislo na tacku (engl. check if the full stop was encountered)
	jb trazi_tacku # ako ne, skoci na labelu "trazi tacku" (engl. if not, jump to "trazi_tacku" label)
	
trazi_slovo: # deo koji se izvrsava ako je pronadjena tacka (engl. part which executes if the full stop was encountered)

	# provera da li je malo slovo (engl. check if the current character is a lowercase letter)
	cmpb $'a', %al
	jb dalje
	cmpb $'z', %al
	ja dalje
	
	subl $'a'-'A', unos(, %esi, 1) # povecaj slovo ako jeste malo slovo (engl. if lowercase, change to uppercase)
	movb $0, pronasao_tacku # vrati promenljivu na nulu, da bise opet trazila tacka (engl. unset the variable in order to search for the next full stop)
	jmp dalje

trazi_tacku:
	cmpb $'.', %al # proveri da li je trenutni karakter tacka (engl. check if current character is full stop)
	jne dalje # ako nije, idi dalje (engl. if not, continue)
	movb $1, pronasao_tacku # ako jeste, postavi promenljivu (engl. if yes, set the variable)

dalje:
	incl %esi # predji na sledeci karakter (engl. go to next character)
	jmp prolazak	
	
kraj_stringa:
	# ispis druge poruke (engl. write the second message to output)
	movl $4, %eax
	movl $1, %ebx	
	leal izlaz_str, %ecx
	movl $izlaz_str_len, %edx
	int $0x80
	
	# ispis konacnog stringa (engl. write the transformed string to output)
	movl $4, %eax
	movl $1, %ebx	
	leal unos, %ecx
	movl %edi, %edx
	int $0x80
	
kraj:
	movl $0, %ebx
	movl $1, %eax
	int $0x80

