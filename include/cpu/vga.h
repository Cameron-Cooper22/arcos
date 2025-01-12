#ifndef __CPU_VGA_H
#define __CPU_VGA_H

#include <stdint.h>

enum Colors {

}

static uint8_t fg = 0;
static uint8_t bg = 0;

typedef struct __attribute__((packed)) {
  char c;
  uint8_t color;
} VgaChar;

void vga_print_str(VgaChar* vstr);
void vga_print_char(VgaChar vc);
void clear_vga();



#endif
