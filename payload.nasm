;
; MIT License
;
; Copyright (c) 2020 Ivan Nikolsky
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;

; int execve(const char *filename, char *const argv[], char *const envp[]);
;
; ebx   ->      const char *filename
; ecx   ->      char *const argv[]
; edx   ->      char *const envp[]

section .text
global _start

; entry point

_start:
        xor     eax,    eax     ; zero-initialize eax
        xor     edx,    edx     ; zero-initialize eax
        mov     al,     0xb     ; int execve(const char *filename, char *const argv[], char *const envp[]);

        ; first command block

        push    edx             ; save NULL value to edx
        push    word    0x632d  ; -c value
        mov     edi,    esp     ; save -c value to edi
        
        ; second command block

        push    edx             ; save NULL value to edx
        push    0x6873          ; sh value
        push    0x2f6e6962      ; /bin value
        push    0x2f2f2f2f      ; //// value
        mov     ebx,    esp     ; save /////bin/sh value to ebx
        
        push    edx             ; save NULL value to edx

        jmp short cmd_data      ; jump to take the command

; args point

args:
        push    edi             ; push -c value
        push    ebx             ; push /////bin/sh value
        mov     ecx,    esp     ; save /////bin/sh -c cmd NULL
        int     0x80            ; exit program

; cmd_data point

cmd_data:
        call args               ; call args
        cmd: db         "ls"    ; set command value
