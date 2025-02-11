#include <drivers/vga.h>
#include "../arch/x86_64/bootseq/multiboot.h"
#include <stdint.h>

int kmain(unsigned long magic, unsigned long mbi) {
  (void) mbi;

  uint16_t attr = 0x1f00;

  if (magic != MB2_MAGIC) attr = 0x4f00;
  
  clear_buffer(attr);

  vga_putchar((vga_height/2) * (vga_width/2), 'H');

  while (1) {
    __asm__ volatile("hlt");
  }

  return 0;
}
