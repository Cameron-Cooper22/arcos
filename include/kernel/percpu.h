#ifndef __ARCOS_PERCPU
#define __ARCOS_PERCPU

#include "atomic.h"
#include "kernel/smp.h"
#include <kernel/addr.h>
#include <stdint.h>

struct percpu {
  struct task* current_task;
  virtaddr_t rsp_scratch; // temporary for syscalls
  virtaddr_t tss; // holds value of tss, needed for context switching
  uint64_t preempt_count; // incremented per lock help and dev per lock release
  
  atomic32_t int_depth;
  bool reschedule;

  cpuid_t id;
  uint8_t apic_id;
  struct runq *run_queue;
}

#endif
