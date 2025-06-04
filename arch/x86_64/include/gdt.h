#ifndef __ARCOS_X86_64_GDT
#define __ARCOS_X86_64_GDT

#include <stdint.h>

#define GDT_PL_0 0
#define GDT_PL_1 1
#define GDT_PL_2 2
#define GDT_PL_3 3


#define GDT_SEGMENT_TYPE_DATA_READ_ONLY 0
#define GDT_SEGMENT_TYPE_DATA_READ_ONLY_ACCESSED 1
#define GDT_SEGMENT_TYPE_DATA_READ_WRITE 2
#define GDT_SEGMENT_TYPE_DATA_READ_WRITE_ACCESSED 3
#define GDT_SEGMENT_TYPE_DATA_READ_ONLY_EXPAND_DOWN 4
#define GDT_SEGMENT_TYPE_DATA_READ_ONLY_EXPAND_DOWN_ACCESSED 5
#define GDT_SEGMENT_TYPE_DATA_READ_WRITE_EXPAND_DOWN 6
#define GDT_SEGMENT_TYPE_DATA_READ_WRITE_EXPAND_DOWN_ACCESSED 7
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_ONLY 8
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_ONLY_ACCESSED 9
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_READ 10
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_READ_ACCESSED 11
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_ONLY_CONFORMING 12
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_ONLY_CONFORMING_ACCESSED 13
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_READ_CONFORMING 14
#define GDT_SEGMENT_TYPE_CODE_EXECUTE_READ_CONFORMING_ACCESSED 15
#define GDT_SEGMENT_TYPE_TSS_64_BIT_AVAILABLE 

#define GDT_LIMIT_GRANULARITY_BYTE  0
#define GDT_LIMIT_GRANULARITY_4KB  1

#define GDT_NOT_PRESENT 0
#define GDT_PRESENT 1

#define GDT_DESCRIPTOR_TYPE_SYSTEM 0
#define GDT_DESCRIPTOR_TYPE_CODE_OR_DATA 1

#define GDT_NUM_ENTRIES 10
#define TSS_NUM_ENTRIES 1

struct gdt_entry_t {
  uint16_t limit_low;
  uint16_t base_low;
  uint8_t base_middle;
  uint8_t seg_type: 4;
  uint8_t descriptor_type: 1;
  uint8_t dpl: 2;
  uint8_t present: 1;
  uint8_t limit_high: 4;
  uint8_t avl: 1;
  uint8_t l: 1;
  uint8_t db: 1;
  uint8_t g: 1;
  uint8_t base_high;
} __attribute__((packed));

struct gdt_ptr_t {
  uint16_t limit;
  uint64_t base;
} __attribute__((packed));

struct TSS {
  uint32_t reserved_0;
  uint64_t rsp0;
  uint64_t rsp1;
  uint64_t rsp2;
  uint64_t reserved_3;
  uint64_t ist1;
  uint64_t ist2;
  uint64_t ist3;
  uint64_t ist4;
  uint64_t ist5;
  uint64_t ist6;
  uint64_t ist7;
} __attribute__((packed)) TSS;

struct tss_entry_t {
  uint16_t limit_low;
  uint16_t base_low;
  uint8_t base_middle;
  uint8_t seg_type: 4;
  uint8_t descriptor_type: 1;
  uint8_t dpl: 2;
  uint8_t present: 1;
  uint8_t limit_high: 4;
  uint8_t avl: 1;
  uint8_t l: 1;
  uint8_t db: 1;
  uint8_t g: 1;

  uint8_t base_high;
  uint32_t base_top;
  uint32_t reserved;
} __attribute__((packed));

struct gdt_t {
  struct gdt_entry_t gdt_entries[GDT_NUM_ENTRIES];
  struct tss_entry_t tss_entries[TSS_NUM_ENTRIES];
} __attribute__((packed));

__attribute__((aligned(8)))
struct gdt_t gdt;

#endif
