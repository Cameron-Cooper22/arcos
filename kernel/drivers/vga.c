#include <drivers/vga.h>
#include <stdint.h>

static uint16_t CURSOR_POS[] = {0, 0};

void clear_top() {
  for (uint16_t i = 0; i < VGA_COLS; i++) {

  }
}

void print_char(char c) {
  if (++CURSOR_POS[0] == VGA_ROWS)
    clear_top();
}


static inline uint16_t vga_entry(unsigned char c, uint8_t color) {
  return (uint16_t) c | (uint16_t) color << 8;
}
