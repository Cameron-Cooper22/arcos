#ifndef __ARCOS_VGA
#define __ARCOS_VGA

#include <stdint.h>
#include "../arch/x86_64/bootseq/boot.h"

const uint64_t vga_buffer = KERNEL_VMA + 0x000b8000;
const uint16_t vga_width = 80;
const uint16_t vga_height = 25;
const uint16_t vga_size = vga_width * vga_height;

uint16_t *vga = (uint16_t *) vga_buffer;

static inline void clear_buffer(uint16_t attr) {
  int i;
  for (i = 0; i < vga_size; ++i) {
    vga[i] = attr;
  }
}

static inline void vga_putchar(uint16_t offset, unsigned char c) {
  vga[offset] = vga[offset] | c;
}

#endif
