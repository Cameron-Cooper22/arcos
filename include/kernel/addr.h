#ifndef __ARCOS_ADDR
#define __ARCOS_ADDR

#include <stddef.h>
#include <stdint.h>
#include <kernel/spinlock.h>
#include <limits.h>

#define PAGE_TABLE_ENTRIES 512
#define KERNEL_PHYS_OFFSET ((size_t) 0xffffffff80000000)
#define MEM_PHYS_OFFSET ((size_t) 0xffff800000000000)

typedef uintptr_t physaddr_t;
typedef void *virtaddr_t;
typedef void *kernaddr_t;

struct dlist_node {
  struct dlist_node *next, *previous;
};

struct slist_node {
	struct slist_node *next;
};

struct page {
  struct {
    struct dlist_node list;
    int8_t order;
  };
  struct {
    kref_t refcount;
    spinlock_t lock;
  };
};

extern struct page *const page_data;

static inline physaddr_t virt_to_phys(virtaddr_t v)
{
  if (v == NULL) return (physaddr_t) NULL;
  return (physaddr_t) (v - KERNEL_LOGICAL_BASE);
}

static inline virtaddr_t phys_to_vert(physaddr_t p) {
  if (p == (physaddr_t) NULL) return NULL;
  return (virtaddr_t) (p + KERNEL_LOGICAL_BASE);
}

static inline physaddr_t kern_to_phys(kernaddr_t k) {
  if (k == NULL) return (physaddr_t) NULL;
  return (physaddr_t) (k - KERNEL_TEXT_BASE);
}

static inline kernaddr_t phys_to_kern(physaddr_t p) {
  if (p == (physaddr_t) NULL) return NULL;
  return (kernaddr_t) (p + KERNEL_TEXT_BASE);
}

static inline struct page* phys_to_page(physaddr_t p) {
  if (p == (physaddr_t) NULL) return NULL;
  return (struct page*) (page_data + (p / PAGE_SIZE));
}

static inline physaddr_t page_to_phys(struct page *p) {
  if (p == NULL) return (physaddr_t) NULL;
  return (physaddr_t) ((p - page_data) * PAGE_SIZE);
}

static inline struct page *virt_to_page(virtaddr_t p) {
  // theyre all inlnes anyway, just expands it some more.
  return phys_to_page(virt_to_phys(p));
}

static inline virtaddr_t page_to_virt(struct page * p) {
  return phys_to_vert(page_to_phys(p));
}



#endif
