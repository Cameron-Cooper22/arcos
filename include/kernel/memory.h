#ifndef __ARCOS_MEMORY
#define __ARCOS_MEMORY

#include "atomic.h"
#include "kernel/spinlock.h"
#include <kernel/addr.h>
#include <limits.h>
#include <stddef.h>
#include <stdint.h>

typedef uint64_t pte_t;

struct page_table {
  pte_t pages[PAGE_TABLE_ENTRIES];
} __attribute__((packed, aligned(PAGE_SIZE)));

struct mem_map_region {
  uintptr_t base;
  size_t len;
  enum mem_map_region_flags {
    MEM_MAP_NONE,
    MEM_MAP_NOMAP
  } flags;
};

struct mem_map_type {
  uint32_t count;
  struct mem_map_region* regions;
};

struct mem_map {
  physaddr_t highest_mapped;
  struct mem_map_type available;
  struct mem_map_type reserved;
};

struct zone {
  struct slist_node list;
  physaddr_t pa_start;
  size_t len;
  struct page* free_lists[MAX_ORDER];
};

/* virtual memory flags */
#define VM_AREA_OTHER 0
#define VM_AREA_STACK 1
#define VM_AREA_TEXT  2
#define VM_AREA_BSS   3
#define VM_AREA_WRITABLE (1 << 0)
#define VM_AREA_EXECUTABLE (1 << 1)

struct vm_area {
  struct slist_node list; 
  uintptr_t base;
  size_t len;
  uint32_t type;
  uint32_t flags;
};

struct mmu_info {
  struct page_table* p4;
  rwspinlock_t pgtab_lock;

  kref_t users;

  spinlock_t cpu_lock;
  cpuset_t cpus;
  spinlock_t area_lock;
  struct vm_area* areas;
};

#endif
