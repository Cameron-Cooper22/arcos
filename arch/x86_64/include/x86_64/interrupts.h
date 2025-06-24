#ifndef __ARCOS_X86_64_INTERRUPTS
#define __ARCOS_X86_64_INTERRUPTS

#include <stdint.h>

#define IDT_MAX_DESCRIPTORS 256

struct idt_entry_t {
    uint16_t isr_low;
    uint16_t kernel_cs;
    uint8_t  ist;
    uint8_t  attributes;
    uint16_t isr_mid;
    uint32_t isr_high;
    uint32_t reserved;
} __attribute__((packed));

__attribute__((aligned(0x10)))
static struct idt_entry_t idt[256];

struct idtr_t {
    uint16_t limit;
    uint64_t base;
} __attribute__((packed));


__attribute__((noreturn))
void exception_handler(void);

void idt_set_descriptor(uint8_t vec, void* isr, uint8_t flags);


extern void* isr_stub_table[];

void idt_init(void);

#endif
