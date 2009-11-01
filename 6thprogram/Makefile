a.out: mysubs.o prog5.o insertionSort.o
	ld -m elf_i386 mysubs.o prog5.o insertionSort.o
mysubs.o: mysubs.asm
	nasm -f elf mysubs.asm
insertionSort.o: insertionSort.asm
	nasm -f elf insertionSort.asm
prog5.o: prog5.asm
	nasm -f elf prog5.asm

clean: 
	rm *.o a.out
