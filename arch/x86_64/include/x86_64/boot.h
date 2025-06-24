#ifndef __ARCOS_X86_64_BOOT
#define __ARCOS_X86_64_BOOT

#define KERNEL_VMA 0xffffffff80000000
#define KERNEL_CS  0x08
#define KERNEL_DS  0x10
#define USER_CS    0x18 | 0x3
#define USER_DS    0x20 | 0x3
#define TSS_SEL	   0x28

#endif
