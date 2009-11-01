; program example cosc 2331
; author:  Dr. Laura Baker
; prints hello world to screen.
; prompts user to enter name
; outputs message with user name


; uninitialized data sectiom
 section .bss  
 our_name resb 30
 name_len resd 1
 our_major resb 50
 major_len resd 1

;section declaration for defined data (must be initialized)
 section .data          
 hello_msg db "Hello my fine feathered friend! ",10  ; the 10 is the newline(LineFeed)  
 len1 equ $ - hello_msg            ; length of the message
 prompt_name db "What is your callsign? "
 len3 equ $ - prompt_name    ; length of the prompt
 welcome_msg db "Welcome to nasm "
 len2 equ $ - welcome_msg   ; length of the message
 major_msg db "What is your major? "
 len4 equ $ - major_msg	    ; length of message
 newline db  10             ; our own string for a LineFeed(LF)

 section .text     ;  section declaration for instructions

               ;we must export the entry point to the ELF linker or
 global _start ;loader. They conventionally recognize _start as their
               ;entry point. Use ld -e foo to override the default.
 _start:

  ;write our hello world message (it includes lf)
    mov edx,len1             ;  message length
    mov ecx, hello_msg       ; second argument: pointer to message to write
    mov ebx,1                ; first argument: file handle (stdout)
    mov eax,4                ;system call number (sys_write)
    int 0x80       ; call kernel to perform the interrupt (output string)

   ; now output prompt for name
    mov edx,len3             ;  message length
    mov ecx, prompt_name     ; second argument: pointer to message to write
    mov ebx,1                ; first argument: file handle (stdout)
    mov eax,4                ;system call number (sys_write)
    int 0x80        ; call kernel to perform the interrupt (output string)
b1:   
   ; now read the name   
    mov edx, 30            ; max chars to read
    mov ecx, our_name     ; where to store input value
    mov ebx, 2             ; where to read from (stdin)
    mov eax, 3             ; read 
    int 0x80        ; call kernel to perform the interrupt (input string)
  
   ; now save size of string input 
   ; which is placed into the eax register by interupt

    dec eax                ; don't count newline
    mov dword [name_len], eax  

  ; write our first prompt string to stdout
    mov edx,len2             ;  message length
    mov ecx,welcome_msg      ; second argument: pointer to message to write
    mov ebx,1                ; first argument: file handle (stdout)
    mov eax,4                ;system call number (sys_write)
    int 0x80        ; call kernel to perform the interrupt
 
    mov edx, dword [name_len]
    mov ecx, our_name
    mov ebx, 1
    mov eax, 4
    int 0x80        ; call kernel to perform the interrupt

 ; now output prompt for name
    mov edx,len4             ;  message length
    mov ecx, major_msg     ; second argument: pointer to message to write
    mov ebx,1                ; first argument: file handle (stdout)
    mov eax,4                ;system call number (sys_write)
    int 0x80        ; call kernel to perform the interrupt (output string)
b2:   
   ; now read the name   
    mov edx, 30            ; max chars to read
    mov ecx, our_major     ; where to store input value
    mov ebx, 2             ; where to read from (stdin)
    mov eax, 3             ; read 
    int 0x80        ; call kernel to perform the interrupt (input string)

    dec eax                ; don't count newline
    mov dword [name_len], eax  

  ; write our first prompt string to stdout
    mov edx,len4             ;  message length
    mov ecx,major_msg       ; second argument: pointer to message to write
    mov ebx,1               ; first argument: file handle (stdout)
    mov eax,4                ;system call number (sys_write)
    int 0x80        ; call kernel to perform the interrupt
 
    mov edx, dword [major_len]
    mov ecx,our_major
    mov ebx, 1 
    mov eax, 4
    int 0x80        ; call kernel to perform the interrupt


  ; now print the newline
    mov edx, 1      		; 1 character to print
    mov ecx, newline            ; load address of character
    mov ebx, 1                  ;  ebx = 1
    mov eax, 4                  ;  eax = 4
    int 0x80        ; call kernel to perform the interrupt

  ; now exit the program    
    mov ebx, 0       		; the stop interrupt
    mov eax, 1                  ; eax = 0, ebx = 1
    int 0x80        ; call kernel to perform the interrupt (stop)
