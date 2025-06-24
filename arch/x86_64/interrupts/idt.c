#include <x86_64/interrupts.h>
#include <x86_64/boot.h>
#include <stdint.h>

static struct idtr_t idtr;
void idt_set_descriptor(uint8_t vec, void *isr, uint8_t flags) {
    struct idt_entry_t* descriptor = &idt[vec];

    descriptor -> isr_low		= (uint64_t) isr & 0xffff;
    descriptor -> kernel_cs	= KERNEL_CS; // TODO: Define this
    descriptor -> ist		= 0;
    descriptor -> attributes	= flags;
    descriptor -> isr_mid		= ((uint64_t) isr >> 16) & 0xffff;
    descriptor -> isr_high	= ((uint64_t) isr >> 32) & 0xffffffff;
    descriptor -> reserved	= 0;
}
static uint8_t vectors[IDT_MAX_DESCRIPTORS];
void idt_init(void) {
    idtr.base = (uintptr_t) (&idt - KERNEL_VMA);
    idtr.limit = (uint16_t) sizeof(struct idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;

    for (uint8_t vec = 0; vec < 32; vec++) {
	idt_set_descriptor(vec, isr_stub_table[vec], 0x8e);
	vectors[vec] = 0xff; //enabled
    }

    __asm__ volatile ("lidt %0" : : "m" (idtr));
    __asm__ volatile ("sti");
}

