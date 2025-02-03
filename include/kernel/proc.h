#ifndef __ARCOS_PROCESSES
#define __ARCOS_PROCESSES

#include <stdint.h>

#define TASK_KTHREAD (1 << 0)
#define TASK_RUNNING (1 << 1)
#define TASK_PREEMPTED (1 << 2)
#define TASK_NONE 0

#define FORK_KTHREAD (1 << 0) // kernel thread
#define FORK_UTHREAD (1 << 1) // user thread

#define TID_IDLE 0

#define MAX_SLICES 5

typedef int32_t tgid_t;
typedef int32_t tid_t;

struct sched_entity {
  struct rb_node node;
}

#endif
