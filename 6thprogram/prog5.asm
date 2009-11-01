; File: prog5.asm
; Author: Andrew Plunk
; Description: Is the main method, calls subroutines to ask the user for a list of 10 ints,
	;converts them to the screen, prints the largest number in the list, the smallest number in the list, and
	;the rounded average of the numbers of the list.
; 2009-10-05

extern writeString, readString, newLine, string_to_int, readList, print_list, intToString, insertSort, strcmp, readStringList, printString_list

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
sortMsg db "Here is your sorted array: "
sortMsg_len equ $ - sortMsg
strPrompt db "Please enter a list of up to 10 names, with a maximum of 30 chars each"
strPrompt_len equ $ - strPrompt
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

call newLine

print_sort_msg:
	push dword sortMsg_len
	push dword sortMsg
	call writeString

call_insertionSort:
	push dword [count]
	push dword list
	call insertSort

print_sorted_list:
	push dword [count]
	push dword list
	call print_list

call newLine

;write_string_Array_prompt:
;	push dword strPrompt_len  ;setup the second arguement
;	push dword strPrompt ;setup the first argument
;	call writeString

;	call newLine

;list_read_str_List:
;	push dword 10
;	push dword list
;	call readStringList
;	mov [count], eax

;print_String_array_contents_prompt:;tell the user what they entered in the array
;	push dword arrayContents_len
;	push dword arrayContents
;	call writeString

;echo_String_array_contents:
;	push eax ;count
;	push dword list
;	call printString_list

;call newLine




quit:
	;exit the program
	mov ebx, 0	;stop the interrupt
	mov eax, 1	
	int 80h 	;call kernel to perform the interrupt (stop)


