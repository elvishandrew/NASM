; File: prog4.asm
; Author: Andrew Plunk
; Description: Is the main method, calls subroutines to ask the user for a list of 10 ints,
	;converts them to the screen, prints the largest number in the list, the smallest number in the list, and
	;the rounded average of the numbers of the list.
; 2009-10-05

extern writeString, readString, newLine, string_to_int, readList, print_list, greatest, intToString, average, least

global _start ;flag those routines that should be found outside
		;of this file
section .bss
;;;;;;;;;;;;;;;
list resd 10 	;create an array
count resd 1
stor resd 16


section .data
prompt db "Please enter a list of up to 10 numbers."
prompt_len equ $ - prompt ;save the length of prompt
arrayContents db "Here is what you entered: "
arrayContents_len equ $ - arrayContents ;length of arrayContents
maxValue db "Here is the max value: "
maxValue_len equ $ - maxValue ;length of max value
aveValue db "Here is the average value: " 
aveValue_len equ $ - aveValue ;length of average value
leastValue db "Here is the smallest value: "
leastValue_len equ $ - leastValue
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

print_array_contents_prompt:;tell the user what they entered in the array
	push dword arrayContents_len
	push dword arrayContents
	call writeString

echo_array_contents:
	push eax ;count
	push dword list
	call print_list

get_greatest_int:
	push dword [count];check
	push dword list
	call greatest

convert_max_to_string:
	push eax
	push dword stor
	call intToString

call newLine

print_max_value_msg:	
	push dword maxValue_len
	push dword maxValue
	call writeString

call newLine

print_max_value:
	push dword 16
	push dword stor
	call writeString

call newLine

print_ave_value_msg:
	push dword aveValue_len
	push dword aveValue
	call writeString

call newLine

get_average:
	push dword [count];check
	push dword list
	call average

convert_average_to_string:
	push eax
	push dword stor
	call intToString

print_average_value:
	push dword 16
	push dword stor
	call writeString

call newLine

print_least_value_msg:
	push dword leastValue_len 
	push dword leastValue
	call writeString

call newLine


get_least:
	push dword [count];check
	push dword list
	call least

convert_least_to_string:
	push eax
	push dword stor
	call intToString

print_least_value:
	push dword 16
	push dword stor
	call writeString



quit:
	;exit the program
	mov ebx, 0	;stop the interrupt
	mov eax, 1	
	int 80h 	;call kernel to perform the interrupt (stop)


