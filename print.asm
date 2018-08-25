[org 0x7c00]
print_char: ; Prints the character stored in al
  pusha
  mov ah, 0x0e
  int 0x10
  popa
  ret
print_string: ; Prints a null-terminated string at address stored in bx
  pusha
  mov ah, 0x0e
  loop_begin:
    mov al, [bx]
    cmp al, 0x00
    je loop_end
    int 0x10
    add bx, 0x01
    jmp loop_begin
  loop_end:
  popa
  ret
