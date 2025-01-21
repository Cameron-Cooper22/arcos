section .bss
[bits 32]
align 16
stack_bottom:
  resb 0x4000 ; 16 KiB
stack_top:

section .text
global _start
_start:
  mov esp, stack_top ; stack init

  ; check if cpuid exists
  pushfd
  pop eax

  mov ecx, eax

  xor eax, 1 << 21

  push eax
  popfd

  pushfd
  pop eax

  push ecx
  popfd

  xor eax, ecx
  jz .NoCPUID

  ; Check if long mode is supported by processor
  mov eax, 0x80000000
  cpuid
  cmp eax, 0x80000001
  jb .NoLM

  ; technically speaking a20 should be enabled here, but I believe a20 is enabled
  ; by grub2 bootloader? unsure, need to look into this

  ; Setting up paging
  ; if paging is already disabled this is unneeded, but to the best of my knowledge
  ; grub2 does have rudimentary paging
  mov eax, cr0
  and eax, ~(1 << 31) ; clear PG-bit
  mov cr0, eax

  mov edi, 0x1000
  mov cr3, edi
  xor eax, eax
  mov ecx, 4096
  rep stosd
  mov edi, cr3
  mov dword [edi], 0x2003
  add edi, 0x1000
  mov dword [edi], 0x3003
  add edi, 0x1000
  mov dword [edi], 0x4003
  add edi, 0x1000
  mov ebx, 0x00000003
  mov ecx, 0x200

.NoCPUID:
  jmp .hang

.NoLM:
  jmp .hang

.hang:	hlt
  jmp .hang

.SetEntry:
  mov dword [edi], ebx
  add ebx, 0x1000
  add edi, 0x08
  loop .SetEntry

  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  mov ecx, 0xc0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  mov eax, cr0
  or eax, 1 << 31
  mov cr0, eax

PRESENT		equ 1 << 7
NOT_SYS		equ 1 << 4
EXEC		equ 1 << 3
DC		equ 1 << 2
RW		equ 1 << 1
ACCESSED	equ 1 << 0

GRAN_4K equ 1 << 7
SZ_32	equ 1 << 6
LM 	equ 1 << 5

GDT:
  .Null: equ $ - GDT
    dq 0
  .Code: equ $ - GDT
    dd 0xffff
    db 0
    db PRESENT | NOT_SYS | EXEC | RW
    db GRAN_4K | SZ_32 | 0xf
    db 0
  .Data: equ $ - GDT
    dd 0xffff
    db 0
    db PRESENT | NOT_SYS | RW
    db GRAN_4K | SZ_32 | 0xf
    db 0
  .TSS: equ $ - GDT
    dd 0x00000068
    dd 0x00cf8900
  .Pointer:
    dw $ - GDT - 1
    dq GDT

  lgdt [GDT.Pointer]
  jmp GDT.Code:lm_start

extern kmain
[bits 64]
lm_start:
  cli
  mov ax, GDT.Data
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  mov edi, 0xb8000
  mov rax, 0x1f201f201f201f20
  mov ecx, 500
  call kmain
  hlt


