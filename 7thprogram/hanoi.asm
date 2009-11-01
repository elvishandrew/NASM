; File: hanoi.asm
; Author: Andrew Plunk
; Description: solves the towers  of hanoi problem
	;using move_ring
; 2009-10-30

global hanoi
extern writeString, stringToInt, move_ring
section .bss

section .data


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
else:
;call hanoi
	dec ecx		;n = n -1
	push ebx	;mid address
	push edx 	;dst address
	push esi	;src address
	push ecx
	call hanoi

;call move_ring
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

 		






