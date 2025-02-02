#ifndef __ARCOS_INTERRUPTS
#define __ARCOS_INTERRUPTS

#include <stdint.h>

#define GDT_OFFSET_KERNEL_CODE 0x08
#define IDT_MAX_DESCRIPTORS 256

typedef struct {
  uint16_t	isr_low;
  uint16_t	kernel_cs;
  uint8_t	ist;
  uint8_t	attributes;
  uint16_t	isr_mid;
  uint32_t	isr_high;
  uint32_t	reserved;
} __attribute__((packed)) idt_entry_t;

typedef struct {
  uint16_t	limit;
  uint64_t	base;
} __attribute__((packed)) idtr_t;

__attribute__((noreturn))
void exception_handler(void);

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t  flags);

void idt_init(void);

#endif
