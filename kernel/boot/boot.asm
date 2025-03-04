  GDT_PRESENT equ 1 << 15
  GDT_CODE equ 3 << 11
  GDT_LONG equ 1 << 21
  PAGE_SIZE equ 0x1000
  PAGE_PRESENT equ 0x01
  PAGE_WRITE equ 0x02
  ENTRIES_PER_PT equ 512

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
  dq BootP3 + (PAGE_PRESENT | PAGE_WRITE)
  times (ENTRIES_PER_PT - 1) dq 0 ; once again i fucking love nasm
BootP3:
  dq BootP2 + (PAGE_PRESENT | PAGE_WRITE)
  times (ENTRIES_PER_PT - 1) dq 0
BootP2:
  dq BootP1 + (PAGE_PRESENT | PAGE_WRITE)
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
  mov esp, BootStack_Top

  ; TODO: Check for cpuid and other lm information, for now just fail
  ;	  with unhandled errors if 32 bit.

  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  mov eax, BootP4
  mov cr3, eax

  mov ecx, 0x0c0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  mov eax, cr0
  or eax, 1 << 31
  mov cr0, eax

  lgdt [BootGDTp]

  jmp 0x8:lm_start

  [bits 64]
lm_start:
  mov eax, 0x0
  mov ss, eax
  mov ds, eax
  mov es, eax

  jmp $
