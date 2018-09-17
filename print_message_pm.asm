[bits 32] ; This function is coded for 32 bit real mode

;Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

;Prints null-terminated string pointed to by EDX

print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY

  print_string_pm_loop:
    mov al, [ebx] ;Only need two bytes
    mov ah, WHITE_ON_BLACK

    cmp al, 0
    je print_string_pm_done

    mov [edx], ax
    add ebx, 1 ;Increment address by one byte
    add edx, 2 ;Increment address by two bytes

    jmp print_string_pm_loop

    print_string_pm_done:
      popa
      ret
