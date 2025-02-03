#ifndef __ARCOS_ASM_HELPER
#define __ARCOS_ASM_HELPER

#include <stdint.h>

static inline uint64_t msr_read(uint64_t msr)
{
  uint32_t lo, hi;
    __asm__ volatile ("rdmsr" : "=a"(lo), "=d"(hi) : "c"(msr));
    return ((uint64_t) hi << 32) | lo;
}

static inline void msr_write(uint64_t msr, uint64_t value) {
  uint32_t lo = value & 0xffffffff;
  uint32_t hi = value >> 32;
  __asm__ volatile ("wrmsr" : : "c"(msr), "a"(lo), "d"(hi));
}

static inline void invlpg(uint64_t addr) {
  __asm__ volatile ("invlpg (%0)" : : "b"(addr) : "memory");
}

static inline void outb(uint16_t port, uint8_t val) {
  __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
  uint8_t ret;
  __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
  return ret;
}

static inline void cli(void) {
  __asm__ volatile ("cli" : : : "cc");
}

static inline void sti(void) {
  __asm__ volatile ("sti" : : : "cc");
}

static inline void irq_enable(void) {
  sti();
}

static inline void irq_disable(void) {
  cli();
}

static inline void barrier(void) {
  __asm__ volatile ("" : : : "memory");
}

static inline void pause(void) {
  __builtin_ia32_pause();
}

static inline uintptr_t read_cr3(void) {
  uintptr_t rv;
  __asm__ volatile ("mov %%cr3, %0" : "=a"(rv) :);
  return rv;
}

static inline void write_cr3(uintptr_t cr3) {
  __asm__ volatile ("mov %0, %%cr3" : : "a"(cr3) : "memory");
}

static inline void bochs_magic(void) {
  __asm__ volatile ("xchg %%bx, %%bx" : : : "rbx");
}

static inline uint64_t read_rflags(void) {
  return __builtin_ia32_readeflags_u64();
}

static inline void write_rflags(uint64_t rflags) {
  __builtin_ia32_writeeflags_u64(rflags);
}

static inline void preempt_inc(void) {
  __asm__ volatile ("lock incl %%gs:0x18" : : );
}

static inline void preempt_dec(void) {
  __asm__ volatile ("lock decl %%gs:0x18" : : );
}

#endif
