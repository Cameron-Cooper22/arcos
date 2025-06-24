#define ASM_FILE
#include <x86_64/multiboot2.h>
#include <x86_64/boot.h>
#include <x86_64/memory.h>

.globl kmain
.code32
.section .multiboot
.align 0x08
mb2_header_start:
    .long MB2_HEADER_MAGIC
    .long MULTIBOOT_ARCHITECTURE_I386
    .long mb2_header_end - mb2_header_start
    .long -(MB2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (mb2_header_end - mb2_header_start))
mb2_header_end:

.section .text
.globl _start
_start:
    cli
    mov V2P(stack_top), %esp

    call check_mb2

    call enable_paging

    lgdt gdt64_ptr - KERNEL_VMA
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %ss
    ljmp $0x08, $long_mode_entry - KERNEL_VMA

check_mb2:
    cmp $0x36d76289, %eax
    jne .hang
    ret


enable_paging:
    mov $pml4_table - KERNEL_VMA, %eax
    mov %eax, %cr3

    mov %cr4, %eax
    or $0x20, %eax
    mov %eax, %cr4

    mov %cr0, %eax
    or $0x80000000, %eax
    mov %eax, %cr0

    mov $0xc0000080, %ecx
    rdmsr
    or $0x00000100, %eax
    wrmsr

    ret

.section .data
.align 0x10
gdt64:
    .quad 0x0000000000000000  # Null
    .quad 0x00af9a000000ffff  # Kernel Code segment
    .quad 0x00af92000000ffff  # Kernel Data segment

.align 0x10
gdt64_ptr:
    .word V2P(gdt64_ptr) - V2P(gdt64) - 1
    .long V2P(gdt64)

.align 0x1000
pml4_table:
    .quad (pdpt_table + 0x03) # Have to use + due to relative addressing. fucking hate it but its fine
    .fill 0x01fe,0x08,0x00
    .quad (pdpt_table + 0x03)

pdpt_table:
    .quad (pd_table + 0x03)
    .fill 0x01fd,0x08,0x00
    .quad (pd_table + 0x03)
    .fill 0x0001,0x08,0x00

pd_table:
    .quad 0x0000000000000000 | 0x83  # 2 MiB pages, RW + Present
    .quad 0x0000000000200000 | 0x83  # 2 MiB pages, RW + Present
    .fill 0x01fe,0x08,0x00

.section .bss
.align 16
stack_bottom:
    .skip 4096
stack_top:

.extern kmain
.code64
.section .text
long_mode_entry:
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %ss

    lea kmain(%rip), %rax
    jmp *%rax

.hang:
    cli
.hang_loop:
    hlt
    jmp .hang_loop
