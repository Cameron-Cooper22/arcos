#ifndef __ARCOS_CPU_H
#define __ARCOS_CPU_H

#include <stdint.h>

struct cpu {
  void *cpu;
  uint64_t gdt[6];
  uint8_t tss[104];
  struct process *proc;
  struct process *scheduler;
};

void cpu_init();

void load_gdt();

uint64_t read_cr0();
uint64_t read_cr2();
uint64_t read_cr3();
void write_cr3(uint64_t);
uint64_t read_cr4();

#define KERNEL_GS_BASE 0xC0000102

#endif
