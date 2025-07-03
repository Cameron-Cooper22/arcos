#define ASM_FILE
#include <x86_64/multiboot2.h>
#include <x86_64/boot.h>
#include <x86_64/memory.h>

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
    /* make sure interrupts are off */
    cli
    
    /* load the GDT */
    lgdt (init_gdt64_ptr - KERNEL_VMA)

    /* give ourselves a functional stack */
    movl $(init_stack_end - KERNEL_VMA), %esp
    
    /* reset EFLAGS. */
    pushl $0
    popf
    
    /* store the multiboot info */
    pushl %eax
    pushl %ebx
    
    /* zero out bss section */
    xorl    %eax, %eax
    movl    $(_bss - KERNEL_VMA), %edi
    movl    $(_end - KERNEL_VMA), %ecx
    subl    %edi, %ecx
    
    cld
    rep	stosb
    
    /* get the multiboot info back */
    popl %esi
    popl %edi
    
    /* ensure that paging is off */
    movl    %cr0, %eax
    andl    $0x7fffffff, %eax
    movl    %eax, %cr0
    
    /* enable CR4.PAE */
    movl    %cr4, %eax
    orl     $0x20, %eax
    movl    %eax, %cr4

    /* set IA32_EFER.LME */
    movl    $0xc0000080, %ecx
    rdmsr
    /* set the PAE and SYSENTER bits */
    orl     $0x00000101, %eax
    wrmsr
    
    /* at this point we should be in IA-32e mode */
    ljmp $0x08, $(boot64 - KERNEL_VMA)

.data
.align 16
gdt64:
    .quad 0x0000000000000000 // 0x00 NULL
    .quad 0x00209A0000000000 // 0x08 KCODE64
gdt64_end:

.align 16
init_gdt64_ptr:
    .word gdt64_end - gdt64 - 1
    .long gdt64 - KERNEL_VMA

/* ident map of first 4MB GB, and mirror it at the -2GB mark  */
.align 0x1000
init_pml4:
    .quad init_pdp - KERNEL_VMA + 3 // [0x0000000000000000 - 0x00000007ffffffff)
    .fill 510,8,0
    .quad init_pdp - KERNEL_VMA + 3 // [0xfffffff800000000 - 0xffffffffffffffff)

init_pdp:
    .quad init_pd - KERNEL_VMA + 3
    .fill 509,8,0
    .quad init_pd - KERNEL_VMA + 3
    .fill 1,8,0

init_pd:
    .quad 0x0000000000000083 // 0MB - 2MB
    .quad 0x0000000000200083 // 2MB - 4MB
    .fill 510,8,0


init_stack_start:
    .fill 0x1000,1,0
init_stack_end:

.extern kmain
.code64
.section .text

boot64:
    movabsq $boot64_high, %rax
    jmp *%rax

boot64_high:
    mov init_pml4 - KERNEL_VMA, %rax
    mov %rax, %cr3

    movq $KERNEL_VMA, %rax
    addq %rax, %rsp
    movq $0x0, init_pml4
    invlpg 0

    call kmain

.hang:
    cli
.hang_loop:
    hlt
    jmp .hang_loop
