#define ASM_FILE	1
#include <multiboot2.h>

#ifdef HAVE_ASM_USCORE
#define EXT_C(sym)	_
#else
#define EXT_C(sym)	sym
#endif

#define STACK_SIZE	0x4000

#ifdef __ELF__
#define AOUT_KLUDGE 	0
#else
#define AOUT_KLUDGE MULTIBOOT_AOUT_KLUDGE
#endif
  
  .code32
  .section .multiboot
  .align 8
multiboot_header:
  .long MB2_HEADER_MAGIC
  .long MULTIBOOT_ARCHITECTURE_I386
  .long multiboot_header_end - multiboot_header
  .long -(MB2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))

#ifndef __ELF__
address_tag_start:
  .short MULTIBOOT_HEADER_TAG_ADDRESS
  .short MULTIBOOT_HEADER_TAG_OPTIONAL
  .long address_tag_end - address_tag_start
  .long multiboot_header
  .long _start
  .long _edata
  .long _end
address_tag_end:
framebuffer_tag_start:
  .short MULTIBOOT_HEADER_TAG_FRAMEBUFFER
  .short MULTIBOOT_HEADER_TAG_OPTIONAL
  .long framebuffer_tag_end - framebuffer_tag_start
  .long 1024
  .long 768
  .long 32
framebuffer_tag_end:

  .globl bootstrap, init_pml4, init_pdp, init_pd
bootstrap:
  cli

  lgdt (init_gdt64_ptr - KERNEL_VMA)

  movl $(init_stack_end - KERNEL_VMA), %esp

  pushl $0
  popf

  pushl %eax
  pushl %ebx

  xorl %eax, %eax
  movl $(_bss - KERNEL_VMA), %edi
  movl $(_end - KERNEL_VMA), %ecx
  subl %edi, %ecx
  cld
  rep	stosb

  popl %esi
  popl %edi

  movl %cr0, %eax
  andl $0x7fffffff, %eax
  movl %eax, %cr0

  movl %cr4, %eax
  orl $0x20, %eax
  movl %eax, %cr4

  movl $(init_pml4 - KERNEL_VMA), %eax
  mov %eax, %cr3

  movl $0xc0000080, %ecx
  rdmsr

  orl $0x00000101, %eax
  wrmsr

  movl %cr0, %eax
  orl $0x80000000, %eax
  movl %eax, %cr0

  ljmp $0x08, $(boot64 - KERNEL_VMA)

.data
.align 16
gdt64:
  .quad 0x0000000000000000
  .quad 0x0020980000000000
gdt64_end:

.align 16
init_gdt64_ptr:
  .word gdt64_end - gdt64 - 1
  .long gdt64 - KERNEL_VMA

  .align 0x1000
init_pml4:
  .quad init_pdp - KERNEL_VMA + 3
  .fill 510,8,0
  .quad init_pdp - KERNEL_VMA + 3

init_pdp:
  .quad init_pd - KERNEL_VMA + 3
  .fill 509,8,0
  .quad init_pd - KERNEL_VMA + 3
  .fill 1,8,0

init_pd:
  .quad 0x0000000000000083
  .quad 0x0000000000200083
  .fill 510,8,0

init_stack_start:
  .fill 0x1000,1,0
init_stack_end:

.code64
boot64_high:
  movq $KERNEL_VMA, %rax
  addq %rax, %rsp

  movq $0x0, init_pml4
  invlpg 0

  call EXT_C(kmain)

boot64_hang:
  hlt
  jmp boot64_hang

boot64:
  movabsq $boot64_high, %rax
  jmp *%rax
