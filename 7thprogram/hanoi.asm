; File: hanoi.asm
; Author: Andrew Plunk
; Description: solves the towers  of hanoi problem
	;using move_ring and hanoi
; 2009-10-30

global hanoi, move_ring
extern writeString, stringToInt, intToString, newLine
section .bss
	rings resb 16
	ringLen resd 1
	ringstor resb 16


section .data
	mvMsg db "Move ring # "
	mv_len equ $ - mvMsg
	srcMsg db " from "
	src_len equ $ - srcMsg
	dstMsg db " to "
	dst_len equ $ - dstMsg



section .text
_start:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;hanoi
;void hanoi (#rings, src addr, mid addr, dst addr)
;manages move_ring to solve the towers of hanoi
hanoi:
	push ebp
	mov ebp, esp
	pushad
	
	mov edx, [ebp + 20]	;get the dst addr
	mov ebx, [ebp + 16]	;get the mid addr
	mov esi, [ebp + 12]	;get the src addr
	mov ecx, [ebp + 8]	;get the # rings
;is n <= 0?
	cmp ecx, 0
	jle done

;is n == 1?
	cmp ecx, 1
	jne else
	push edx
	push esi
	push ecx
	call move_ring
	jmp done	;check!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
else:
;call hanoi
	dec ecx		;n = n -1
	push ebx	;mid address
	push edx 	;dst address
	push esi	;src address
	push ecx
	call hanoi

;call move_ring
	inc ecx
	push edx	;dst address
	push esi	;src address
	push ecx
	call move_ring

;call hanoi
	dec ecx		;check!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	push edx	;dst address
	push esi	;src address
	push ebx	;mid address
	push ecx	
	call hanoi


done:
	popad
	pop ebp
	ret 16

 		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;move_ring
;void move_ring(ring#, src addr, dst addr)
;prints "move ring # from src addr to dst addr"
move_ring:
	push ebp
	mov ebp, esp
	pushad

	mov edx, [ebp + 16]	;dst addr
	mov esi, [ebp + 12]	;src addr
	mov ecx, [ebp + 8]	;ring#


wait:
	push ecx
	push ringstor
	call intToString

	push eax
	push ringstor
	call writeString
	
	push src_len
	push srcMsg
	call writeString

	push dword 7
	push esi
	call writeString

	push dst_len
	push dstMsg
	call writeString

	push dword 7
	push edx
	call writeString

	call newLine

	popad
	pop ebp
	ret 12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end of move ring







