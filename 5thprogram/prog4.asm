; File: prog4.asm
; Author: Andrew Plunk
; Description: Is the main method, calls subroutines to ask the user for a list of 10 ints,
	;converts them to the screen, prints the largest number in the list, the smallest number in the list, and
	;the rounded average of the numbers of the list.
; 2009-10-05

extern writeString, readString, newLine, string_to_int, readList

global _start ;flag those routines that should be found outside
		;of this file
section .bss
;;;;;;;;;;;;;;;
list resd 10 	;create an array
count resd 1


section .data
prompt db "Please enter a list of up to 10 numbers."
prompt_len equ $ - prompt ;save the length of prompt

section .text

_start:

;setup write string with the prompt message
write_string_prompt:
	push dword prompt_len ;setup the second arguement
	push dword prompt ;setup the first argument
	call writeString

print_newline:
	call newLine

list_read_List:
	push dword 10
	push dword list
	call readList
	mov [count], eax




quit:
	;exit the program
	mov ebx, 0	;stop the interrupt
	mov eax, 1	
	int 80h 	;call kernel to perform the interrupt (stop)



