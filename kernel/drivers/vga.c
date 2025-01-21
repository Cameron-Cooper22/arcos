#include <drivers/vga.h>
#include <stdint.h>

void clear_top(void) {
  for (uint16_t i = 0; i < VGA_COLS; i++) {
    
  }
}

// TODO: Implement a buffer for scrolling in both directions
void vga_scroll(int line) {
  int loop;
  char c;
  
  for(loop = line * (VGA_COLS * 2) + 0xB8000; loop < VGA_COLS * 2; loop++) {
    // c = *loop;
    // *(loop - (VGA_COLS * 2)) = c;
  }
}

void print_char(unsigned char c) {
  uint16_t entry = vga_entry(c, vga_entry_color(vga_fg, vga_bg));
  if (++x_pos > (VGA_COLS - 0x01)) {
    x_pos = 0;
    if (++y_pos > VGA_ROWS - 1) {
      y_pos--;
      vga_scroll(1);
    }
  }
  VGA_BUFFER[x_pos * (y_pos + 1)] = entry;
}


static inline uint16_t vga_entry(unsigned char c, uint8_t color) {
  return (uint16_t) c | (uint16_t) color << 8;
}

static inline uint8_t vga_entry_color(uint8_t fg, uint8_t bg) {
  return (fg << 8) | bg;
}

void vga_clear(void) {
  uint16_t c = vga_entry(' ', vga_entry_color(vga_fg, vga_bg));
  for (uint16_t i = 0; i < VGA_ROWS * VGA_COLS; i++) {
    VGA_BUFFER[i] = c;
  }
}

void vga_clear_upper_rows(uint8_t nr) {
  uint16_t c = vga_entry(' ', vga_entry_color(vga_fg, vga_bg));
  if (nr > VGA_ROWS) nr = VGA_ROWS; // buffer overflow protection
  for (uint16_t i = 0; i < VGA_COLS * nr; i++) {
    VGA_BUFFER[i] = c;
  }
}

void vga_clear_row(uint8_t nr) {
  uint16_t c = vga_entry(' ', vga_entry_color(vga_fg, vga_bg));
  if (nr > VGA_ROWS) nr = VGA_ROWS - 1;
  for (uint16_t i = nr * VGA_COLS; i < VGA_COLS; i++) {
    VGA_BUFFER[i] = c;
  }
}

