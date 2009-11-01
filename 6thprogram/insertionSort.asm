 ;File: insertionSort.asm
 ;Author: Andrew Plunk
 ;Description: 
 ;2009-10-24

global insertSort, strcmp

section .text
_start:

;void insertionSort (addr of array of ints, #elements in array)
;a routine that accepts an array address and the number
;of elements in the array, sorts the array in acending 
;order and saves the sorted array at arrayaddr;

insertSort:
	push ebp
	mov ebp, esp
	pushad

	mov ecx, [ebp + 12] ;get # elements
	cmp ecx, 1
	jle done_sort
	mov edi, [ebp + 8] ;get array addr
	mov ebx, edi ;save the stopping address for inner
	dec ecx ;repeat loop n-1 times
outer: add edi, 4 ;edi is pointing at list[i]

	mov esi, edi ; copy it
	sub esi, 4 ;esi is list [k -1]
	mov edx, [edi] ;get list[i] into a register

inner:
	cmp esi, ebx ;make sure we have not gone back too far
	jb done_inner 	;for unsigned compairing addresses
	cmp edx, [esi]	;if(list[k] < list [k -1])
	jge done_inner

;this is the swap of list[k] and list[k-1]
	push dword [esi]	;push list[k-1]
	push dword [esi + 4]	;push list[k]
	pop dword [esi]
	pop dword [esi + 4]
	sub esi, 4
	jmp inner
done_inner: loop outer	;go get next element to insert

done_sort: popad
	pop ebp
	ret 8


;write subroutine str cmp that recieves 2 null-terminated string addresses
;int strcmp(addr str1, addr str2)
strcmp:
	push ebp
	mov ebp, esp
	;push any rgisters used
	push ebx
	push esi
	push edi
	mov esi, [ebp + 8] ;esi = addr str1
	mov edi, [ebp + 12]

next_char:
	mov bl, [esi] ;next char in str1
	mov bh, [edi] ;next char in str2

	test bl, bl
	je end_str1
	test bh, bh
	je end_str2

	cmp bl, bh
	jg str1_bigger
	jl str1_smaller
	inc esi
	inc edi
	jmp next_char

str1_bigger:
	mov eax, 1
	jmp done

str1_smaller:
	mov eax, -1
	jmp done

end_str1:
	test bh, bh
	jnz str1_smaller
	mov eax, 0
	jmp done

end_str2:
	test bl, bl
	jnz str1_bigger
	mov eax, 0
done:
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret 8
