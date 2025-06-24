#include <x86_64/interrupts.h>

void exception_handler() {
  __asm__ volatile ("cli; hlt");
}
