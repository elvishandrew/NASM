a.out: andrewHello.o hello.o trihello.o
	ld -m elf_i386 andrewHello.o hello.o trihello.o
prog1.o: andrewHello.asm hello.asm trihello.asm
	nasm -f elf andrewHello.asm hello.asm trihello.asm
clean:
	rm *.o a.out
