#include <driver/vga.h>

int kernel_main() {
  set_cursor_pos(0, 0);
  clear_win(COLOR_BLK, COLOR_YEL);

  const char *first = "\n\n\nWe can now handle some special characters.";
  putstr(first, COLOR_BLK, COLOR_YEL);

  const char *second = "\nLike tab \t and newline";
  putstr(second, COLOR_BLK, COLOR_YEL);

  const char *third = "\nAnd it scrolls!";

  for (u16_t i = 0; i < 30; i++) {
    putstr(third, COLOR_BLK, COLOR_YEL);
  }

  return 0;
}
