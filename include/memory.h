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

extern union PTE BootP4;
extern int _kernel_start, _kernel_end;

void *memcpy(void *dst, const void *src, size_t n);
void *memset(void *s, int c, size_t n);
void *memmove(void *dest, const void *src, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);
size_t strlen(const char *s);

void pmm_free(uint64_t page);
uint64_t pmm_alloc();
uint64_t pmm_calloc();

uint64_t new_P4();
uint64_t vmm_get_page(uint64_t P4, uint64_t addr);
#define PAGE_EXIST(p) ((p) != (uint64_t)-1)
int vmm_set_page(uint64_t P4, uint64_t addr, uint64_t page, uint16_t flags);
void vmm_clear_page(uint64_t P4, uint64_t addr, int free);
size_t memcpy_to_p4(uint64_t P4, void *dst, void *src, size_t n);
size_t memcpy_from_p4(void *dst, uint64_t P4, void *src, size_t n);

#endif
