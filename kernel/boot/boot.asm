  GDT_PRESENT equ 1 << 15
  GDT_CODE equ 3 << 11
  GDT_LONG equ 1 << 21
  PAGE_SIZE equ 0x1000
  PAGE_PRESENT equ 0x01
  PAGE_WRITE equ 0x02
  ENTRIES_PER_PT equ 512
  KERNEL_OFFSET equ 0xffffff8000000000

%define V2P(x) (x - KERNEL_OFFSET)
%define P2V(x) (x + KERNEL_OFFSET)

  section .bss
  align PAGE_SIZE
BootStack_Bottom:
  resb PAGE_SIZE
BootStack_Top:

  section .rodata
  global BootGDT
BootGDT:
  dd 0, 0
  dd 0, (GDT_PRESENT | GDT_CODE | GDT_LONG)

  global BootGDTp
BootGDTp:
  dw 2*8-1
  dq BootGDT ; god i fucking love nasm

  section .data
  align PAGE_SIZE
  global BootP4
BootP4:
  dq V2P(BootP3) + (PAGE_PRESENT | PAGE_WRITE)
  times (ENTRIES_PER_PT - 2) dq 0 ; once again i fucking love nasm
  dq V2P(BootP3) + (PAGE_PRESENT | PAGE_WRITE)
BootP3:
  dq V2P(BootP2) + (PAGE_PRESENT | PAGE_WRITE)
  times (ENTRIES_PER_PT - 1) dq 0
BootP2:
  dq V2P(BootP1) + (PAGE_PRESENT | PAGE_WRITE)
  times (ENTRIES_PER_PT - 1) dq 0
BootP1:
  %assign i 0
  %rep ENTRIES_PER_PT
    dq (1 << 12) + (PAGE_PRESENT | PAGE_WRITE)
    %assign i i+1
  %endrep

  section .text
  global _start
  [bits 32]
_start:
  cli
  mov esp, V2P(BootStack_Top)

  ; TODO: Check for cpuid and other lm information, for now just fail
  ;	  with unhandled errors if 32 bit.

  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  mov eax, V2P(BootP4)
  mov cr3, eax

  mov ecx, 0x0c0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  mov eax, cr0
  or eax, 1 << 31
  mov cr0, eax

  lgdt [V2P(BootGDTp)]

  jmp 0x8:V2P(lm_start)

  [bits 64]
lm_start:
  mov eax, 0x0
  mov ss, eax
  mov ds, eax
  mov es, eax
  mov fs, eax
  mov gs, eax

  mov rax, upper_memory
  jmp rax

upper_memory:
  mov rax, KERNEL_OFFSET
  add rsp, rax

  mov rax, 0
  mov [BootP4], rax

  mov rax, cr3
  mov cr3, rax

  mov rax, BootGDTp
  lgdt [rax]
  mov rax, 0x0
  mov ss, rax
  mov ds, rax
  mov es, rax

  mov rax, reload_cs
  push 0x8
  push rax
  retfq
reload_cs:

  extern kmain
  mov rax, kmain
  call rax

  hlt
  jmp $
