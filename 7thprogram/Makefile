a.out: mysubs.o prog7.o hanoi.o
	ld -m elf_i386 mysubs.o prog7.o hanoi.o
hanoi.o: hanoi.asm
	nasm -f elf hanoi.asm
mysubs.o: mysubs.asm
	nasm -f elf mysubs.asm
prog7.o: prog7.asm
	nasm -f elf prog7.asm
clean: 
	rm *.o a.out
