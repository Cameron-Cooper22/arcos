#include <memory.h>

.section .bss
.align PAGE_SIZE
.skip PAGE_SIZE
BootStack:

.section .text
.intel_syntax noprefix
.code32
.global _start
_start:
  cli
  mov esp, offset V2P(BootStack)
  
  // PAE bit
  mov eax, cr4
  or eax, 1<<5
  mov cr4, eax
  
  // load BootP4
  mov eax, offset V2P(BootP4)
  mov cr3, eax

  // set EFER.LME
  mov ecx, 0x0C0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  // enabling Paging
  mov eax, cr0
  or eax, 1<<31
  mov cr0, eax

  // load gdt
  lgdt [V2P(BootGDTp)]

  // update CS via long jump
  jmp 0x8:V2P(lm_start)

.code64
lm_start:
  mov eax, 0x0
  mov ss, eax
  mov ds, eax
  mov es, eax
  mov fs, eax
  mov gs, eax

  movabs rax, offset upper_memory
  jmp rax

upper_memory:
  movabs rax, KERNEL_OFFSET
  add rsp, rax

  mov rax, 0
  movabs [BootP4], rax

  mov rax, cr3
  mov cr3, rax

  lgdt [rax]
  mov rax, 0x0
  mov ss, rax
  mov ds, rax
  mov es, rax
  mov fs, rax
  mov gs, rax

  movabs rax, offset .reload_cs
  pushq 0x8
  push rax
  retfq

.reload_cs:
.extern kmain
  movabs rax, offset kmain
  call rax

  hlt
  jmp $
