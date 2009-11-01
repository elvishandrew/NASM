a.out: mysubs.o prog4.o
	ld -m elf_i386 mysubs.o prog4.o
mysubs.o: mysubs.asm
	nasm -f elf mysubs.asm
prog4.o: prog4.asm
	nasm -f elf prog4.asm

clean: 
	rm *.o a.out
