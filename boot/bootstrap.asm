;boot sector code that boots a C kernel in 32-bit protected mode

[org 0x7c00]
[bits 16]
KERNEL_OFFSET equ 0x1000

  mov [BOOT_DRIVE], dl
  mov bx, 0x07E0
  mov ss, bx
  mov bx, 0
  mov ds, bx
  mov es, bx
  mov bp, 0x1200
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  call load_kernel

  call switch_to_pm

%include "print.asm"
%include "disk_read.asm"
%include "print_message_pm.asm"
%include "gdt.asm"
%include "enter_pm.asm"

[bits 16]

;load_kernel
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET
  mov dh, 15
  mov dl, [BOOT_DRIVE]
  call disk_load

  ret

[bits 32]
[extern main]
BEGIN_PM:

mov ebx, MSG_PROT_MODE
call print_string_pm

call KERNEL_OFFSET

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

; Bootsector padding

times 510 - ($ - $$) db 0
dw 0xaa55
