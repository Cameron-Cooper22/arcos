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
#define incptr(p, n) ((void *)(((uintptr_t)(p)) + (n)))
#endif

#define P1_OFFSET(a) (((a)>>12) & 0x1FF)
#define P2_OFFSET(a) (((a)>>21) & 0x1FF)
#define P3_OFFSET(a) (((a)>>30) & 0x1FF)
#define P4_OFFSET(a) (((a)>>39) & 0x1FF)

#define PAGE_PRESENT      0x001
#define PAGE_WRITE        0x002
#define PAGE_USER         0x004
#define PAGE_HUGE         0x080
#define PAGE_GLOBAL       0x100

#define PAGE_SIZE       0x1000
#define ENTRIES_PER_PT  512

#endif
