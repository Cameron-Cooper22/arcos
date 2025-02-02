#include <kernel/interrupts.h>
#include <stdint.h>
#include <stdbool.h>

__attribute__((aligned(0x10)))
static idt_entry_t idt[256];

static idtr_t idtr;

static bool vectors[IDT_MAX_DESCRIPTORS];

extern void* isr_stub_table[];

void idt_init(void) {
  idtr.base = (uintptr_t) &idt[0];
  idtr.limit = (uint16_t) sizeof(idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;
  uint8_t vector;
  for (vector = 0; vector < 32; vector++) {
    idt_set_descriptor(vector, isr_stub_table[vector], 0x8e);
    vectors[vector] = true;
  }

  __asm__ volatile ("lidt %0" : : "m"(idtr)); //loads new idt
  __asm__ volatile ("sti"); //sets interrupt flag
}

__attribute__((noreturn))
void exception_handler(void) {
  __asm__ volatile ("cli; hlt"); // hang the computer
}

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags) {
  idt_entry_t* descriptor = &idt[vector];

  descriptor -> isr_low		= (uint64_t) isr & 0xffff;
  descriptor -> kernel_cs	= GDT_OFFSET_KERNEL_CODE;
  descriptor -> ist		= 0;
  descriptor -> attributes	= flags;
  descriptor -> isr_mid		= ((uint64_t) isr >> 16) & 0xffff;
  descriptor -> isr_high	= ((uint64_t) isr >> 32) & 0xffffffff;
  descriptor -> reserved	= 0;
}
