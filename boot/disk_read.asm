; load DH sectors to ES:BX from drive DL
; Requires inclusion of print.asm
disk_load:
  push dx ;Store DX on stack so later we can recall
  push 0x0
disk_retry:
  mov ah, 0x02 ;BIOS read sector function
  mov al, dh ;Read DH sectors
  mov ch, 0x00 ;Select cylinder 0
  mov dh, 0x00 ;Select head 0
  mov cl, 0x02 ; Read from second sector (skip boot sector)

  int 0x13 ;BIOS interrupt
  pop dx
  add bx, 1
  push bx
  cmp bx, 5
  jne done
  jc disk_retry
  done:
  jc disk_error ;'jc' jumps if the carry flag is set
  pop dx
  pop dx ;Get what drive and sectors
  cmp dh, al
;  jne disk_error_didnt_read_all
  ret

disk_error:

  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $

disk_error_didnt_read_all:
  mov bx, DISK_ERROR_MSG_2
  call print_string
  jmp $

;Variables
DISK_ERROR_MSG db "Disk read error flag set!", 0
DISK_ERROR_MSG_2 db "Did not read the correct amount of segments", 0
