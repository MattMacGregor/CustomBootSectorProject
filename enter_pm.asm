[bits 16]
switch_to_pm:
cli
lgdt [gdt_descriptor]
mov eax, cr0
or eax, 0x1
mov cr0, eax ; Update control register to enter protected mode
jmp CODE_SEG:start_protected_mode ; Initiate far jump

[bits 32]

start_protected_mode:

; We are now in 32 bit protected start_protected_mode
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000
  mov esp, ebp

  jmp BEGIN_PM
