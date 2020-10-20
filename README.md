# Potion Payload

*Linux method of executing system commands*

Potion Payload is a method of executing system commands through shellcodes and nasm executables on Linux.

## Explaining

Potion Payload uses Linux `execve()` system call that allows you to execute filename.

```c
int execve(const char *filename, char *const argv[], char *const envp[]);
```

Potion Payload fills this function like this, it uses file `/bin/sh` with option `-c` to execute system commands.

```c
int execve("/////bin/sh", ["/////bin/sh", "-c", cmd], NULL);
```

Linux `execve()` registers:

| Register | Value |
|----------|-------|
| `ebx`    | `const char *filename` |
| `ecx`    | `char *const argv[]`   |
| `edx`    | `char *const envp[]`   |

**0.** Setup entry point

```nasm
section .text
global _start
```

**1.** Set all registers and make a system call

```nasm
xor     eax,    eax     ; zero-initialize eax
xor     edx,    edx     ; zero-initialize eax
mov     al,     0xb     ; int execve(const char *filename, char *const argv[], char *const envp[]);
```

**2.** Save `-c` value to `edi`

```nasm
push    edx             ; save NULL value to edx
push    word    0x632d  ; -c value
mov     edi,    esp     ; save -c value to edi
```

**3.** Save `/////bin/sh` value to `ebx`

```nasm
push    edx             ; save NULL value to edx
push    0x6873          ; sh value
push    0x2f6e6962      ; /bin value
push    0x2f2f2f2f      ; //// value
mov     ebx,    esp     ; save /////bin/sh value to ebx
```

**4.** Push NULL to edx to avoid `envp[]` errors.

```nasm
push    edx             ; save NULL value to edx
```

**5.** Take command data

```nasm
jmp short cmd_data      ; jump to take the command
```

**command data:**

```nasm
cmd_data:
        call args               ; call args
        cmd: db         "ls"    ; set command value
```

**6.** Call args from `cmd_data` (save arguments to `ecx`)

```nasm
args:
        push    edi             ; push -c value
        push    ebx             ; push /////bin/sh value
        mov     ecx,    esp     ; save /////bin/sh -c cmd NULL
        int     0x80            ; exit program
```

## Usage

**Get payload:**

```
make payload
./payload
```

**Get shellcode:**

```
make shellcode
```

**Get debug:**

```
make debug
```
