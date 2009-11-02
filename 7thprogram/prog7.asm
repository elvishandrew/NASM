; File: prog7.asm
; Author: Andrew Plunk
; Description: calls prompts the user for a number of rings and calls hanoi
; 2009-10-29

extern writeString, readString, newLine, stringToInt, readList, print_list, intToString, hanoi, move_ring

global _start:

section .bss
	rings resb 16
	ringLen resd 1
	ringstor resb 16


section .data
	towerA db "Tower A"
	towerB db "Tower B"
	towerC db "Tower C"
	towerLen equ $ - towerC
	prompt db "Enter the number of rings to solve for: "
	promptLen equ $ - prompt
	nNotation db "Here is the number of moves it will take to solve hanoi: "
	nLength equ $ - nNotation
	;these are the messages printed by move_ring

section .text

_start:
;;;;;;;;;;;;;;;;;;;;;;write prompt
	push promptLen
	push prompt
	call writeString

;;;;;;;;;;;;;;;;;;;;;;read number of rings
	push ringLen
	push rings
	call readString

;;;;;;;;;;;;;;;;;;;;;;convert ring string to int
	push eax
	push rings
	call stringToInt

;;;;;;;;;;;;;;;;;;;;;;print nNotation string
	push nLength 
	push nNotation
	call writeString

call newLine

	
;calculate the number of moves hanoi will make
	;get int # rings in ecx
	mov ecx, eax 
	mov eax, 1
	;convert # rings to 2^n - 1
	shl eax, cl
	dec eax

	push eax
	push rings
	call intToString

	push ringLen
	push rings
	call writeString

call newLine

	push towerC
	push towerB
	push towerA
	push ecx
	call hanoi

quit:
	;exit the program
	mov ebx, 0	;stop the interrupt
	mov eax, 1	
	int 80h 	;call kernel to perform the interrupt (stop)


