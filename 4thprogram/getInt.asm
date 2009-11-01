;;  this version works as of Sept. 5, 2007
;  getInt.asm
;  Author: Laura Baker
;  
;  Description:  program that asks user for an integer
;   prints that integer (as a string) back to the screen
;  uses int 80h i/o methods write and read

  global _start  ;; declares start as externally known 

section .data
   prompt db 'Enter an integer: '
   plen equ $-prompt
   prompt1 db 13,10,'Here is what you input: '
   prompt1len equ $-prompt1
   newline db 13,10

  section .bss
   intValueString  resb 15      ;  reserve 15 bytes for number's chars
   intValueLen     resd 1       ;  store number of chars in string here

  section .text

_start:
  ; first prompt for input value using int80h write string
     mov edx, plen   ;  length of string
     mov ecx, prompt ;  address of string 
     mov ebx, 1      ;   file handle 1 is for standard output to write to
     mov eax, 4      ;  interrupt number for write
     int 80h

  ; now read input value (stored into address at ecx, count in eax)
  ; use int 80h for reading a string
     mov edx, 15         ;  at most read 15 bytes max to read 
     mov ecx, intValueString  ;  address of string to store chars read
     mov ebx, 2          ; file handle is  2 for standard input
     mov eax, 3          ;  interrupt number for read
     int 80h   ;  call read string
               ;  now the string read is stored and count of chars is in eax

     dec eax   ;  take away 1 for the CR  (remember eax has number chars read)
     mov [intValueLen], eax    ;  store # chars in read

break1: 
        ;  now output message stating here is the value
     mov edx, prompt1len  ; number of chars to write
     mov ecx, prompt1     ;  string address
     mov ebx, 1        ;  std output is place to write to
     mov eax, 4        ;  write interrupt # 4
     int 80h

;  now output original value read
     mov edx, [intValueLen]  ;  number of chars to write
     mov ecx, intValueString ;   address of chars to write
     mov ebx, 1              ;  file handle for stdout
     mov eax, 4              ;  int 80h's write # 
     int 80h   ;  call write 


; now output a newline
     mov edx, 2
     mov ecx, newline
     mov ebx, 1
     mov eax, 4
     int 80h   ;  call write 
    
;  now exit the program
    mov eax, 1          ;  interrupt number for exit
    mov ebx, 0          ;  return code 0 is success on system
    int 80h

