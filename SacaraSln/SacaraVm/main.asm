comment !
This is the implementation of the Sacara VM.
2018 (C) Antonio 's4tan' Parata

!

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.DATA
code_0 BYTE 6Dh,0C6h,2h,0h,0h,0h     ; /* 6DC602000000 */ loc_00000000: Push 0x2
code_1 BYTE 23h,2Dh                  ; /*         232D */ loc_00000006: Alloca
code_2 BYTE 7Fh,88h,0h,0h            ; /*     7F880000 */ loc_00000008: Push 0x0
code_3 BYTE 6Dh,0C6h,20h,0h,0h,0h    ; /* 6DC620000000 */ loc_0000000C: Push 0x20
code_4 BYTE 0E8h,22h                 ; /*         E822 */ loc_00000012: Call
code_5 BYTE 0F2h,0C9h,1h,0h          ; /*     F2C90100 */ loc_00000014: Pop 0x1
code_6 BYTE 6Dh,0C6h,14h,0h,0h,0h    ; /* 6DC614000000 */ loc_00000018: Push 0x14
code_7 BYTE 6Fh,4Fh                  ; /*         6F4F */ loc_0000001E: Halt
code_8 BYTE 6Dh,0C6h,42h,0h,0h,0h    ; /* 6DC642000000 */ loc_00000020: Push 0x42
code_9 BYTE 7h,0D7h                  ; /*         07D7 */ loc_00000026: Ret
vm_code_bytes_size EQU $-code_0

.CODE

include const.inc
include strings.inc
include utility.asm
include vm_instructions_headers.inc

; compute size of the code related to the VM. 
; These offset are used by the find_vm_handler routine
start_vm_instructions:
include vm_instructions.inc
vm_instructions_size DWORD $ - start_vm_instructions

include vm.asm

main PROC
	push ebp
	mov ebp, esp
	
	; allocate space on the stack for the VM context and initialize it	
	sub esp, 10h
	mov eax, vm_code_bytes_size
	push eax
	push offset code_0
	push ebp
	call vm_init
	
	; run VM
	push ebp
	call vm_main

	; free vm
	push ebp
	call vm_free

	; cleanup stack from vm_context structure
	add esp, 10h

	; exit
	invoke ExitProcess,0

	mov ebp, esp
	pop ebp
	ret
main ENDP
END main

