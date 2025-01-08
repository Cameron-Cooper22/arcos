bits 16

elevate_bios:
  cli

  lgdt [gdt_32_descriptor]

  mov eax, cr0
  or eax, 0x0000001
  mov cr0, eax

  jmp code_seg:init_pm

  [bits 32]
init_pm:
  mov ax, data_seg
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x9000
  mov esp, ebp

  jmp begin_protected
