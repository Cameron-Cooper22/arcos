#ifndef __ARCOS_X86_64_MEMORY
#define __ARCOS_X86_64_MEMORY


// #ifndef KERNEL_VMA
// #define KERNEL_VMA 0xffffffff80000000
// #endif

#ifdef ASM_FILE
#define P2V(a) ((a) + KERNEL_VMA)
#define V2P(a) ((a) - KERNEL_VMA)
#endif

#ifndef ASM_FILE
#include <stdint.h>
#define P2V(a) ((uint64_t)a + KERNEL_VMA)
#define V2P(a) ((a) - KERNEL_VMA)
#endif

#endif
