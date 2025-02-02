#include <kernel/tty.h>
#include <kernel/interrupts.h>

void kmain(void) {
  idt_init();
  terminal_init();
}
