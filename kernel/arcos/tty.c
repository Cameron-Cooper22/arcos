#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <config.h>
#include <arcos/tty.h>

#include <drivers/vga.h>




static struct {
  size_t terminal_row;
  size_t terminal_col;
} term_cursor;

static uint8_t terminal_color;
static uint16_t* terminal_buffer;

void terminal_init() {
  term_cursor.terminal_row = 0;
  term_cursor.terminal_col = 0;
  // currently no other options for tty so this is fine
#if (VGA_TTY == 1)
  terminal_color = vga_entry_color(vga_fg, vga_bg);
#endif
  terminal_buffer;


}
