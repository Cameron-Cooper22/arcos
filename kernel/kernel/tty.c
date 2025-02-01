#include <kernel/tty.h>
#include <stddef.h>
#include <stdint.h>


static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static uint16_t* const VGA_MEMORY = (uint16_t*) 0xB8000;

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t* terminal_buffer;

void terminal_init(void) {
  terminal_row = 0;
  terminal_column = 0;
  terminal_color = (7) | (0 << 8);
  terminal_buffer = VGA_MEMORY;

  for (size_t y = 0; y < VGA_HEIGHT; y++) {
    for (size_t x = 0; x < VGA_WIDTH; x++) {
      const size_t index = y * VGA_WIDTH + x;
      terminal_buffer[index] = ' ' | terminal_color;
    }
  }
}
