#include <memory.h>

void clear_screen() {
  unsigned char *vga_mem = P2V(0xb8000);
  for (int i = 0; i < 80 * 24 * 2; i++) *vga_mem++ = 0;
}

void print_string(char* str) {
  unsigned char *vga_mem = P2V(0xB8000);
  while (*str) {
    *vidmem++ = *str++;
    *vidmem++ = 0x7;	// 0b0111
  }
}

void kmain() {
  clear_screen();
  print_string("Hello from c, world!");
  for(;;);
}
