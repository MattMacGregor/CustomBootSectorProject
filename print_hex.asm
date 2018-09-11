;THIS IS AWFUL BUT IT WORKS ¯\_(ツ)_/¯
[org 0x7c00]
print_hex: ;Prints the hex value stored in dx
;ASCII 0 is 48 ASCII A is 65 diff 17
;dl, al, bl, cl
  pusha
  mov cl, dl
  mov dl, dh
  mov al, dl
  mov bl, cl
  and al, 0x0f
  shr dl, 4 ;Isolate high 4 bits of high byte
  and bl, 0x0f ;Isolate low 4 bits of low bit
  shr cl, 4 ;Isolate high 4 bits of low byte
  add dl, 0x30
  add al, 0x30
  add bl, 0x30
  add cl, 0x30
  cmp dl, 0x3A
  jl skip1
  add dl, 0x07
  skip1:
  cmp al, 0x3A
  jl skip2
  add al, 0x07
  skip2:
  cmp bl, 0x3A
  jl skip3
  add bl, 0x07
  skip3:
  cmp cl, 0x3A
  jl skip4
  add cl, 0x07
  skip4:
  mov [HEX_OUT + 2], dl
  mov [HEX_OUT + 3], al
  mov [HEX_OUT + 4], cl
  mov [HEX_OUT + 5], bl
  mov bx, HEX_OUT
  call print_string
  popa
  ret
%include "print.asm"
HEX_OUT db '0x0000', 0
