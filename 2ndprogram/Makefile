a.out: prog2.o
	ld -m elf_i386 prog2.o
prog1.o: prog2.asm
	nasm -f elf prog2.asm
clean:
	rm *.o a.out
