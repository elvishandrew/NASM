 ;File: mysubs.asm
 ;Author: Andrew Plunk
 ;Description: Subroutines used by prog3.asm
 ;2009-10-05


;;;delcare global methods
global writeString, stringToInt, readString, newLine, readList, print_list, intToString, greatest, average, least

section .bss
input resb 16  ;check
input_len resd 1

section .data
ten dd 10
error_msg db "That is not valid input"
error_len equ $ - error_msg
prompt_msg db "Please enter an int, x to stop: "
prompt_len equ $ - prompt_msg
section .text 
_start: 

writeString:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
  ;  routine that writes  a string to stdoutput 
  ; void writeString(string addr, int charCount) returns nothing 
    push ebp; establish ebp for this subroutine
    mov ebp, esp

    push eax      ; save 4 registers we will use 
    push ebx
    push ecx
    push edx
               ;; set up int 80h for output a string
    mov eax, 4
    mov ebx, 1
    mov ecx, [ebp+8]    ; address of string is 1st argument
    mov edx, [ebp+12]   ; number of chars in string is 2nd argument
    int 80h
;; restore registers we used
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 8    ;; return and pop 2 arguments from the stack

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
readString:      ;; routine that reads a string from keyboard
                 ;; int readString(string addr, maxCharsToRead)
                 ;; returns #chars read

    push ebp      ;; save old ebp
    mov ebp, esp  ;; establish new ebp
    push ebx      ;; save ebx, ecx, edx (NOT eax though)
    push ecx
    push edx

    mov eax, 3    ;; set up the int 80h call for read a string
    mov ebx, 2
    mov ecx, [ebp+8]   ;; first argument at [ebp+8] -- string address
    mov edx, [ebp+12]  ;; second argument at [ebp+12] -- max chars to read
    int 80h

    dec eax       ;  take away 1 for the newline char
    pop edx
    pop ecx
    pop ebx
    pop ebp       ;; restore the old ebp

    ret 8         ; be sure to pop of 8 bytes for 2 arguments passed 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;; void newLine()  outputs a crlf sequence to screen
;;;;;     no arguments sent - 
 newLine:  
   push ebp               ; save old ebp
   mov ebp,esp            ; establish current ebp
   sub esp, 4             ;  reserve 4 bytes of local memory
   pushad                 ; push all registers (doubleword registers)
   lea esi, [ebp-4]
   mov byte[esi], 13      ; store a cr character (ascii code 13)
   inc esi                ; move up 1 byte for next character
   mov byte [esi], 10     ; store a lf character (ascii code 10)
   lea esi, [ebp-4]       ; load address of ebp-4 into esi (the crlf)
   mov ecx, 2             ; count of chars in crlf string
   push ecx               ; push arg2 ( #chars)
   push esi               ; push arg 1 (addr of string to write)
   call writeString       ; void writeString(addr of string , #chars in string)
   
   popad                  ; restore all registers (pop all doubleword registers)
   add esp, 4             ; remove local stack data
   pop ebp                ; restore old ebp
        
   ret                    ; go back! (no arguments sent, so none to pop)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;; void space()  outputs a space sequence to screen
;;;;;     no arguments sent - 
 space:  
   push ebp               ; save old ebp
   mov ebp,esp            ; establish current ebp
   sub esp, 4             ;  reserve 4 bytes of local memory
   pushad                 ; push all registers (doubleword registers)
   lea esi, [ebp-4]
   mov byte[esi], ''      ; store a cr character (ascii code 13)
   inc esi                ; move up 1 byte for next character
   mov byte [esi], ' '     ; store a lf character (ascii code 10)
   lea esi, [ebp-4]       ; load address of ebp-4 into esi (the crlf)
   mov ecx, 2             ; count of chars in crlf string
   push ecx               ; push arg2 ( #chars)
   push esi               ; push arg 1 (addr of string to write)
   call writeString       ; void writeString(addr of string , #chars in string)
   
   popad                  ; restore all registers (pop all doubleword registers)
   add esp, 4             ; remove local stack data
   pop ebp                ; restore old ebp
        
   ret      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; int strint_to_int(address of string, string length)
;;takes a string, converts it into an int, returns the int
stringToInt: 
push ebp
mov ebp, esp
push ecx
push edi
push edx
;push ebx -> esi
mov ecx, [ebp + 12] ;get length of string
mov edi, [ebp + 8] ;

cmp [edi], byte '-' ;compare what edi points to to -
jne skip_negate
mov edx, 1; negative flag in edx=1
inc edi
dec ecx ;one less character
jmp done_with_sign

skip_negate:
	cmp [edi], byte '+'
	jne skip_plus
	inc edi
	dec ecx
	
skip_plus: xor edx, edx ;set edx  = 0

done_with_sign:
	xor eax, eax ;acc = 0
	mov ebx, 10 ;set multiplier
	push edx ;save sign

top_of_loop:
	mov dl, [edi]
stop:
	cmp dl, '0'
	jb error
	cmp dl, '9'
	ja error
	sub dl, 30h
	mov esi, edx
	mul ebx
	add eax, esi
	inc edi
	loop top_of_loop
	
pop edx
cmp edx, 1
jne end_of_string_to_int
neg eax
jmp end_of_string_to_int

error: ;exit

end_of_string_to_int: ;pop stuff
pop edx
pop edi
pop ecx
pop ebp ;pop and switch
ret 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int readList(addr of array, int max values)
readList: 
	push ebp
	mov ebp, esp
	push ebx
	push edx 
	push esi
	push edi
	push ecx

xor ecx, ecx ;set counter to zero
mov edi, [ebp + 8] ;get address of array into edi
mov ebx, [ebp + 12]

top_while: 
	cmp ecx, ebx ;we are at max values
	jge done_while

;prompt for input
	push dword prompt_len
	push dword prompt_msg
	call writeString
;read input ;eax is # of chars read
	push dword 16 ;or 8
	push dword input
	call readString
;check if input is x

	cmp [input], byte 'x'
	je done_while

	push eax ;#chars in string
	push dword input
	call stringToInt
	mov [edi], eax ;put it out at array address

	add edi,4 ;move to next array index
	inc ecx ;add one to counter
	jmp top_while

done_while: 
	mov eax, ecx ;return value
;pop in reverse order of how you push them
	pop ecx
	pop  edi
	pop esi
	pop edx
	pop ebx
	pop ebp
	ret 8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;String intToString(addr of string, value to convert)
;return stores string in addr, stores # chars stored in
;eax
intToString:
	push ebp
	mov ebp, esp
	push ecx
	push edx
	push edi
	push ebx
	push esi

	mov eax, [ebp + 12] ;get the int value to convert
	xor esi, esi ; esi =0 positive
	mov ebx, 10 ;set divisor
	test eax, eax ;check if eax > 0 < 0 0
	jg positive
	je zero
	neg eax
	inc esi

positive:
	xor ecx, ecx ;count of characters
	loop: test eax, eax
	je done
	xor edx, edx ;clear out for divide
	div ebx ;edx: eax / 10	
	push edx
	inc ecx
	jmp loop


done:
	mov edi, [ebp + 8] ;get address of string
	test esi, esi ;check first char
	je skip_neg ;if zero then not negative
	mov [edi], byte '-'
	inc edi
	mov eax, ecx
	inc eax
	jmp done_sign

skip_neg:
	mov eax, ecx ;no sign
done_sign:
pop_loop:
	pop ebx
	add ebx, 30h
	mov [edi], bl
	inc edi
	loop pop_loop
	jmp done_intToString
	
zero:
	mov edi, [ebp + 8]
	mov [edi], byte '0'
	mov eax, 1

done_intToString:
	pop esi
	pop ebx
	pop edi
	pop edx
	pop ecx
	pop ebp
	ret 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void printList(address of array, array count)
;while there are elements in the array, prints them
print_list:
	push ebp	
	mov ebp, esp
	sub esp, 16 ;allocate 16 bytes for a temp string
	pushad ;save registers
	mov ecx, [ebp + 12];save length of array
	mov edi, [ebp + 8] ;save address of array
	test ecx, ecx
	jz done_printList
	
plistLoop:
	mov eax, [edi] ;get array value
	mov ebx, ebp
	sub ebx, 16
	push eax
	push ebx
	call intToString

	push eax
	push ebx
	call writeString
	call space
	add edi, 4 ;move to the next array element
	loop plistLoop

done_printList:
	popad ;return registers
	add esp, 16 ;;;;check may have to add 16
	pop ebp
	ret 8



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int greatest (addr of array, number of elements)
;returns the largest int in eax
greatest:
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push ecx

	mov edi,[ebp + 8] ;addr of array
	mov ecx,[ebp + 12] ;count
	mov eax, [edi] ;get first array value
	dec ecx
	test ecx, ecx 
	je done_with
	add edi,4
gLoop:
	cmp eax, [edi]
	jge skip_move ;if it is greater or equal we do not want to swap the values
	mov eax, [edi]
skip_move:
	add edi, 4 ;move to the next array index
	loop gLoop

done_with:
	pop ecx
	pop edi
	pop ebx
	pop ebp
	ret 8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int average (addr of array, number of elements)
;returns the largest int in eax
average:
	push ebp
	mov ebp, esp
	push ebx
	push edx
	push edi
	push ecx
	push esi

	mov edi,[ebp + 8] ;addr of array
	mov ecx,[ebp + 12] ;count
	;mov ebx,[ebp + 12] ;count
	mov ebx, ecx

	mov eax, [edi]
	dec ecx
	test ecx, ecx 
	je done_with_average

aLoop:
	add edi, 4
	add eax, [edi]
	loop aLoop

	div ebx ;edx:eax /ebx
	mov esi, eax ;save answer

	mov eax, edx ;get remainder in eax for multiply
	mul dword [ten] ;multiply eax by 10
	cmp eax, ebx
	jl itsSmaller
	inc esi

itsSmaller:
	mov eax, esi ;get the answer back into eax

zzz:
done_with_average:
	pop esi
	pop ecx
	pop edi
	pop edx
	pop ebx
	pop ebp
	ret 8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int least(addr of array, number of elements)
;returns the smallest int in eax
least:
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push ecx

	mov edi,[ebp + 8] ;addr of array
	mov ecx,[ebp + 12] ;count
	mov eax, [edi] ;get first array value
	dec ecx
	test ecx, ecx 
	je done_least
	add edi,4
lLoop:
	cmp eax, [edi]
	jl skip_now ;if it is greater or equal we do not want to swap the values
	mov eax, [edi]
skip_now:
	add edi, 4 ;move to the next array index
	loop lLoop
done_least:
	pop ecx
	pop edi
	pop ebx
	pop ebp
	ret 8

