#include <cpu.h>
#include <memory.h>
#include <interrupts.h>
#include <stdint.h>

void gdt_init(struct cpu *cpu);

struct cpu __seg_gs *cpu = 0;

extern void write_msr(uint32_t, uint64_t);

void cpu_init() {
  // Set up cpu struct
  struct cpu *c = (struct cpu *) P2V(pmm_calloc());
  c->cpu = c;
  write_msr(KERNEL_GS_BASE, (uint64_t)c);
  asm("swapgs");

  interrupt_init();
  gdt_init(cpu->cpu);
}
