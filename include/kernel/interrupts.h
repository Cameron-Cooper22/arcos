#ifndef __ARCOS_INTERRUPTS
#define __ARCOS_INTERRUPTS

#include "kernel/addr.h"
#include <stdint.h>
#include <stdbool.h>

#define GDT_OFFSET_KERNEL_CODE 0x08
#define IDT_MAX_DESCRIPTORS 256
#define IA32_APIC_BASE_MSR 0x1B
#define IA32_APIC_BASE_MSR_BSP 0x100 // Processor is a BSP
#define IA32_APIC_BASE_MSR_ENABLE 0x800

#define IST_NONE 0
#define IST_NMI 1
#define IST_DOUBLE_FAULT 2

#define IRQ_APIC_SPURIOUS 0xFF
#define IRQ_APIC_BASE 0x30
#define IRQ_LINT_BASE (IRQ_APIC_SPURIOUS - 3) // One for each LINT pin, one for timer
#define IRQ_LINT_TIMER (IRQ_LINT_BASE + 2)
#define IRQ_NMI (IRQ_LINT_BASE - 1)

#define IRQ_IPI_TOP (IRQ_NMI - 1)
#define IRQ_IPI_ABORT (IRQ_IPI_TOP - 0)
#define IRQ_IPI_TLB_SHOOTDOWN (IRQ_IPI_TOP - 1)
#define IRQ_IPI_SCHED_HINT (IRQ_IPI_TOP - 2)
#define ISA_TO_INTERRUPT(x) (ioapic_isa_to_gsi(x) + IRQ_APIC_BASE)

struct isr_ctx {
  uint64_t r11;
  uint64_t r10;
  uint64_t r9;
  uint64_t r8;
  uint64_t rax;
  uint64_t rcx;
  uint64_t rdx;
  uint64_t rsi;
  uint64_t rdi;
  uint64_t info;
  uint64_t rip;
  uint64_t cs;
  uint64_t rflags;
  uint64_t rsp;
  uint64_t ss;
};

typedef void (*isr_handler_t)(struct isr_ctx *);

struct isr_info {
  enum isr_type {
    ISR_IRQ, // Normal IRQs that require EOI
    ISR_EXCEPTION, // CPU exceptions like page faults
    ISR_IPI, // IPIs like TLB shootdown
    ISR_NOP, // NOP for spurious interrupts
  } type;
  isr_handler_t handler;
};

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

void exceptions_init(void);
void idt_init(void);
void idt_load(void);
void idt_set_gate(uint8_t index, virtaddr_t entry, uint8_t ist, uint8_t type_attr);

void isr_init(void);
void isr_set_info(uint8_t, struct isr_info*);
void isr_global_handler(struct isr_ctx*);
void isr_irq_eoi(uint8_t);
void isr_irq_mask(uint8_t);
void isr_irq_unmask(uint8_t);

#endif
