#include <kernel/interrupts.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <cpuid.h>
#include <kernel/cpu.h>

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


bool check_apic(void) {
  unsigned int eax, ebx, ecx, edx = 0;
  __get_cpuid(1, &eax, &ebx, &ecx, &edx);
  return edx & CPUID_FEAT_EDX_APIC;
}

static inline void cpu_set_msr(uint32_t msr, uint32_t lo, uint32_t hi) {
  __asm__ volatile ("wrmsr" : : "a"(lo), "d"(hi), "c"(msr));
}

static inline void cpu_get_msr(uint32_t msr, uint32_t *lo, uint32_t *hi) {
  __asm__ volatile ("rdmsr" : "=a"(*lo), "=d"(*hi) : "c"(msr));
}

void cpu_set_apic_base(uintptr_t apic) {
  uint32_t edx = 0;
  uint32_t eax = (apic & 0xffff0000) | IA32_APIC_BASE_MSR_ENABLE;

#ifdef __PHYSICAL_MEMORY_EXTENSION__
  edx = (apic << 32) & 0x0f;
#endif
  cpu_set_msr(IA32_APIC_BASE_MSR, eax, edx);
}

uintptr_t cpu_get_apic_base(void) {
  uint32_t eax, edx;
  cpu_get_msr(IA32_APIC_BASE_MSR, &eax, &edx);

#ifdef __PHYSICAL_MEMORY_EXTENSION__
  return (eax & 0xfffff000)

#endif
}

uint32_t lapic_read(uint32_t reg) {
  size_t lapic_base = (size_t) madt -> local_controller_addr + MEM_PHYS_OFFSET;
  return *((volatile uint32_t *) (lapic_base + reg));
}

void lapic_write(uint32_t reg, uint32_t data) {
  size_t lapic_base = (size_t) madt -> local_controller_addr + MEM_PHYS_OFFSET;
  *((volatile uint32_t *) (lapic_base + reg)) = data;
}

void lapic_enable(void) {
  lapic_write(0xf0, lapic_read(0xf0) | 0x1ff);
}

void init_apic(void) {
  lapic_enable();
  size_t lapic_base = (size_t) madt -> local_controller_addr + MEM_PHYS_OFFSET;
  lapic_eoi_ptr = (uint32_t*) (lapic_base + 0xb0);
}
