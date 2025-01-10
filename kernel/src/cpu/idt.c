#include "types.h"
#include <cpu/idt.h>

idt_gate main_idt[IDT_ENTRIES];
idt_register main_idt_reg;

void set_idt() {
  main_idt_reg.base = (u64_t) &main_idt;
  main_idt_reg.limit = (IDT_ENTRIES * sizeof(idt_gate)) - 1;

  __asm__ volatile ("lidt (%0)" : : "r" (&main_idt_reg));
}

void set_idt_gate(u8_t gate_idx, u64_t handler_address) {
  u16_t low_16 = (u16_t) (handler_address & 0xffff);
  u16_t middle_16 = (u16_t) ((handler_address >> 16) & 0xffff);
  u16_t high_32 = (u32_t) ((handler_address >> 32) & 0xffffffff);

  idt_gate gate = {
    .base_low = low_16,
    .cs_selector = KERNEL_CS,
    .zero = 0,
    .attributes = INT_ATTR,
    .base_middle = middle_16,
    .base_high = high_32,
    .reserved = 0
  };

  main_idt[gate_idx] = gate;
}

