; load DH sectors to ES:BX from drive DL
; Requires inclusion of print.asm
disk_load:
  push dx ;Store DX on stack so later we can recall
  mov ah, 0x02 ;BIOS read sector function
  mov al, dh ;Read DH sectors
  mov ch, 0x00 ;Select cylinder 0
  mov dh, 0x00 ;Select head 0
  mov cl, 0x02 ; Read from second sector (skip boot sector)

  int 0x13 ;BIOS interrupt

  jc disk_error ;'jc' jumps if the carry flag is set

  pop dx ;Get what drive and sectors
  cmp dh, al
  jne disk_error
  ret

disk_error:

  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $

;Variables
DISK_ERROR_MSG db "Disk read error!", 0
