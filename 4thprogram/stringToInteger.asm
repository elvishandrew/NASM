; File: stringToInteger.asm
; Author: Andrew Plunk
; Description: Converts a string to an integer, adds one and outputs the result.
; Last Modified: September 20, 2009

global _start ; delcares start as globally known

section .data
	prompt db "Enter an integer, negative or positive: " ;ask the user for an integer
	prompt_len equ $-prompt ;stores the length of the accepted integer
	echoMessage db "Here is the integer you entered: " ;message for echoing user input
	echo_len equ $-echoMessage ;length of echoMessage
	echoFinal db "Here is the integer that you entered plus 1: "
	echoFinal_len equ $-echoFinal ; length of final message
	ten dd 10

section .bss
	inputInt resb 15 ;reserves 15 bytes for an integer
	int_Len resd 1 ;reserves a doubleword for the length of the integer
	result resb 15 ;reserves 15 bytes for the result
	result_len resd 1
	stor resb 15
section .text

_start:
	

prompt_mesg:
	mov edx, prompt_len ;move into edx the prompt length
	mov ecx, prompt ;move into ecx the message
	mov ebx, 1 ;first argument: file handle(stdout)
	mov eax, 4 ;system call number (sys write)
	int 80h ; call kernel to perform the interrupt (output the string)

accept_int:
	mov edx, 15 ;move into edx the length of the int
	mov ecx, inputInt ;move into ecx where to store the int
	mov ebx, 2 ;where to read from (stdin)
	mov eax, 3 ;read
	int 80h ;perform the interrupt

	dec eax ;take away 1 for the carrage return
	mov [int_Len], eax ;store number of chars to read

print_int_msg:
	mov edx, echo_len ;move into edx the prompt length
	mov ecx, echoMessage;move into ecx the message
	mov ebx, 1 ;first argument: file handle(stdout)
	mov eax, 4 ;system call number (sys write)
	int 80h ; call kernel to perform the interrupt (output the string)

print_int:
	mov edx, [int_Len] ;move into edx the prompt length
	mov ecx, inputInt;move into ecx the message
	mov ebx, 1 ;first argument: file handle(stdout)
	mov eax, 4 ;system call number (sys write)
	int 80h ; call kernel to perform the interrupt (output the string)


check_sign:
	mov esi, inputInt
	mov ecx, [int_Len]
	test ecx, ecx ;check if ecx is zero
	jz no_sign
	xor edx, edx ;clears out edx
	
	mov bl, [esi]
	cmp bl, '+'
	jne skip_plus
	inc esi
	dec ecx
	jmp done_sign

skip_plus:
	cmp bl, '-'
	jne done_sign
	inc esi
	dec ecx
	inc edx	

done_sign:
	push edx
no_sign:
mov edi, result
mov ecx, [result_len]
mov dword[edi], 0

convert_to_int_loop: ;checks if only integers were intered (excluding a - or + at the beginning of the int)
	             ;also converts the string to an integer

	mov bl, [esi]
	cmp bl, 30h ;checks if the next char is a digit
	jb not_a_digit
	cmp bl, 39h
	ja not_a_digit
        sub bl, 30h;makes the next char a digit

	mov [stor], bl	;makes the value of stor become bl
       	mov eax, [stor] ; moves stor's value into eax
       	mul dword [ten] ;eax = eax * 10
      	add eax, [edi] ;eax = eax + value of edi
       	add [edi], eax ;adds eax to the result

       	inc esi; move to next char
	loop convert_to_int_loop

handle_negative:; checks if the negative flag has been set
	mov eax, [result]
	pop edx
	cmp edx, 1
	jne Skip_negative
	neg eax	
	mov edx, 1
	push edx

Skip_negative:
	inc eax ;add one to the result
	xor edx, edx
	push edx

zero_check:
	xor ecx, ecx	;set counter to zero
	inc ecx
	push dword 0	;;;;;check;;;;;;;;;!!!!!!!!!!!!!!
	test eax, eax
	jz done_with_loop

int_to_string_check:
	mov edx, 0 ;clears out edx
	idiv dword[ten] ;edx:eax / 10
	push edx ;
	inc ecx ;increments counter to keep track of stack number

check_zero:
	test eax,eax
	jz done_with_loop
	test eax,eax
	ja int_to_string_check

done_with_loop:
	mov edi, eax
	inc edi ;skip one byte for sign
	
convert_loop:
	pop edx
	add edx, 30h ;convert edx to char
	mov [edi], dl
	inc edi
	loop convert_loop

;check sign of number
check_sign2:
	pop edx
	cmp edx, 1
	je print_neg
	jb print_pos	
	
print_neg:
	mov edx, [int_Len] ;move into edx the prompt length
	mov ecx, inputInt;move into ecx the message
	mov ebx, 1 ;first argument: file handle(stdout)
	mov eax, 4 ;system call number (sys write)
	int 80h ; call kernel to perform the interrupt (output the string)


print_pos:
	
do_nothing:




; now exit the program    
mov ebx, 0                  ; the stop interrupt
mov eax, 1                  ; eax = 0, ebx = 1
int 80h        ; call kernel to perform the interrupt (stop)
