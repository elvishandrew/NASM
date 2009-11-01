a.out: trial.o                          
	ld -m elf_i386 trial.o                         
prog1.o: trial.asm                               
	nasm -f elf trial.asm                             
clean:
	rm *.o a.out
