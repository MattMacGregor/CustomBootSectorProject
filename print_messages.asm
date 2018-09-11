[org 0x7c00] ; Example usage of print.asm
mov bx, hi_msg
call print_string
mov bx, bye_msg
call print_string
jmp $
%include "print.asm"
hi_msg db 'Hi ', 0
bye_msg db 'Bye', 0
times 510 - ($ - $$) db 0
dw 0xaa55
