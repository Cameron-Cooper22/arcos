#include <x86_64/boot.h>

.code64
.extern kmain
.extern init_pml4
.section .text
.global boot64
boot64:

    mov %cr0, %rax
    orl $0x80000000, %eax
    mov %rax, %cr0

    movabsq $boot64_high, %rax
    jmp *%rax

boot64_high:
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

.global qemu_exit
qemu_exit:
    mov    $0xf4, %dx
    mov    $0x42, %al
    outb   %al, (%dx)   # QEMU exits, host sees status 0x42
    ret
