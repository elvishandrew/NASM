; File: stringToInteger.asm
; Author: Andrew Plunk
; Description: Converts a string to an integer, adds one and outputs the result.
; Last Modified: September 20, 2009

global _start ; delcares start as globally known

section .bss
	inputInt resb 15 ;reserves 15 bytes for an integer
	int_Len resd 1 ;reserves a doubleword for the length of the integer
	result resb 15 ;reserves 15 bytes for the result
	result_len resd 1
	stor resb 15

section .data
	prompt db "Enter an integer, negative or positive: " ;ask the user for an integer
	prompt_len equ $-prompt ;stores the length of the accepted integer
	echoMessage db "Here is the integer you entered: " ;message for echoing user input
	echo_len equ $-echoMessage ;length of echoMessage
	echoFinal db "Here is the integer that you entered plus 1: "
	echoFinal_len equ $-echoFinal ; length of final message
	error db "YOU DID NOT ENTER A DIGIT, BYE!"
	error_len equ $-error; length of error message
	ten dd 10 ;the number 10 to multiply by
	minus dw '-' ;a minus sign
	minus_len equ $-minus
	plus dd '+';a plus sign
	plus_len equ $-plus
	newline db 10 ;the newline char

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

print_newline:
     mov edx, 1                  ; 1 character to print
     mov ecx, newline            ; load address of character
     mov ebx, 1                  ;  ebx = 1
     mov eax, 4                  ;  eax = 4
     int 0x80   

final_msg:
	mov edx, echoFinal_len ;move into edx the prompt length
	mov ecx, echoFinal ;move into ecx the message
	mov ebx, 1 ;first argument: file handle(stdout)
	mov eax, 4 ;system call number (sys write)
	int 80h ; call kernel to perform the interrupt (output the string)




check_sign:
	mov esi, inputInt
	mov ecx, [int_Len]
	test ecx, ecx ;check if ecx is zero
	jz no_sign
	xor edx, edx ;clears out edx (sets it to zero)
	
	mov bl, [esi]
	cmp bl, '+';check if the first char of esi is +
	jne skip_plus
	inc esi; go to the next char
	dec ecx;decrement the counter
	jmp done_sign

skip_plus:
	cmp bl, '-';check if the first sign is -
	jne done_sign
	inc esi;go to the next char
	dec ecx;decrement the counter
	mov edx, 1 ;makes edx a one to signify that the number is negative

done_sign:
	push edx ;saves our sign flag

setup_loop:
;ecx was already setup in check_sign
	xor eax, eax

convert_to_int_loop: ;checks if only integers were intered (excluding a - or + at the beginning of the int)
	             ;also converts the string to an integer

h1:	mov bl, [esi]
h2:	cmp bl, 30h ;checks if the next char is a digit
h3:	jb not_a_digit
h4:	cmp bl, 39h
h5:	ja not_a_digit
h6:     sub bl, 30h;makes the next char a digit
h7:	mul dword[ten] ; eax = eax * 10
	mov [stor], bl
h8:	add eax, [stor]
h9:    	inc esi; move to next char
	loop convert_to_int_loop

handle_negative:; checks if the negative flag has been set
;at this point eax has the input stored converted to integer format
	pop edx;get the sign flag
	cmp edx, 1;see if the sign is negative
	jne Skip_negative
	neg eax	;if negative negate eax
	mov edx, 1;setup the negative flag
	push edx;move the flag to the stack
	inc eax ;add one to the result
	neg eax ;move it back to positive
	push edx
	jb setup_stack

no_sign:

Skip_negative:
	inc eax
	push edx

setup_stack:
s1:	xor ecx, ecx ;set counter to zero
s2:	test eax, eax ;test if eax is zero
s5:	jz done ;skips string_loop

stack_loop:
	xor edx, edx ;clear edx for divide
l1:	idiv dword[ten]; edx:eax / 10
l2:	push dword edx ;push remainder to stack
l3:	inc ecx ;increment counter
l4:	test eax, eax ;see if eax is zero
l5:	jz setup_string
l6:	ja stack_loop


;;;;;;;;;;;;print an error message if a nondigit is entered
not_a_digit:
	mov edx, error_len
	mov ecx, error
	mov ebx, 1
	mov eax, 4
	int 80h
	jmp quit


done:
s3:	inc ecx ;if the char is zero skip the stack loop
s4:	push dword 0


setup_string:
	xor edx, edx
	mov edi, result ;moves where we want to store the answer to edi
	inc edi ;skips one place for the sign

string_loop: ;convert back to a string
	pop edx
	add edx, 30h ;check this out
	mov [edi], dl
	inc edi ;move to the next digit
	loop string_loop

;check the sign of the number
	pop edx
	cmp edx, 1
	jne add_plus

add_minus:;print the minus
	mov edx, minus_len
	mov ecx, minus
	mov ebx, 1
	mov eax, 4
	int 80h
	jmp end_finally

add_plus: ;print the plus
	mov edx, plus_len
	mov ecx, plus 
	mov ebx, 1
	mov eax, 4
	int 80h

end_finally: ;print the string of numbers
	mov edx, 15
	mov ecx, result
	mov ebx, 1
	mov eax, 4
	int 80h
quit:
; now exit the program    
	mov ebx, 0                  ; the stop interrupt
	mov eax, 1                  ; eax = 0, ebx = 1
	int 80h        ; call kernel to perform the interrupt (stop)
