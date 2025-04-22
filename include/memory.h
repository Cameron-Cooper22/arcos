#ifndef _ARCOS_MEMORY_H
#define _ARCOS_MEMORY_H

#ifndef KERNEL_OFFSET
#define KERNEL_OFFSET 0xffffff8000000000
#endif

#ifdef __ASSEMBLER__
#define V2P(a) ((a) - KERNEL_OFFSET)
#define P2V(a) ((a) + KERNEL_OFFSET)
#else
#include <stdint.h>
#define V2P(a) ((uintptr_t)(a) & ~KERNEL_OFFSET)
#define P2V(a) ((uintptr_t)(a) | KERNEL_OFFSET)
#endif

#ifndef PAGE_SIZE
#define PAGE_SIZE (0x1000)
#endif

#ifndef PAGE_PRESENT
#define PAGE_PRESENT (0x001)
#endif

#ifndef PAGE_WRITE
#define PAGE_WRITE (0x001)
#endif

#ifndef ENTRIES_PER_PT
#define ENTRIES_PER_PT (0x200)
#endif

#endif
