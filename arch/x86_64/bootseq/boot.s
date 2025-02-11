#define ASM
#include "multiboot.h"
#include "boot.h"

  .extern _start
  .extern _edata
  .extern _end

  .extern KERNEL_VMA

  .globl kmain

  .code32
  .section .multiboot
  .align 4
multiboot_header:
  .long MULTIBOOT_HEADER_MAGIC                             /* magic */
  .long MULTIBOOT_HEADER_FLAGS                             /* flags */
  .long -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS) /* checksum */
  .long (multiboot_header - KERNEL_VMA)                    /* header_addr */
  .long (_start - KERNEL_VMA)                              /* load_addr */
  .long (_edata - KERNEL_VMA)                              /* load_end_addr */
  .long (_end - KERNEL_VMA)                                /* bss_end_addr */
  .long (bootstrap - KERNEL_VMA)                           /* entry_addr */


  .globl bootstrap, init_pml4, init_pdp, init_pd
bootstrap:
  cli
  lgdt (init_gdt64_ptr - KERNEL_VMA)

  movl $(init_stack_end -KERNEL_VMA), %esp

  pushl $0
  popf

  pushl %eax
  pushl %ebx

  xorl %eax, %eax
  movl $(_bss - KERNEL_VMA), %edi
  movl $(_end - KERNEL_VMA), %ecx
  subl %edi, %ecx
  cld

  rep stosb

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

  ljmp $0x08, $(bbot64 - KERNEL_VMA)

  .data
  .align 0x10
gdt64:
  .quad 0x0000000000000000
  .quad 0x0020980000000000
gdt64_end:

  .align 0x10
init_gdt64_ptr:
  .word gdt64_end - gdt64 - 1
  .long gdt64 - KERNEL_VMA

  .align 0x1000
init_pml4:
  .quad init_pdp - KERNEL_VMA + 3
  .fill 510, 8, 0

init_stack_start:
  .fill 0x1000, 1, 0
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

