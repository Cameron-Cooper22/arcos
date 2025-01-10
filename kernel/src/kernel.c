#include "cpu/isr.h"
#include <driver/vga.h>

int kernel_main() {

  init_isr();
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


  putstr("\nThis interrupt is most likely NOT a double-fault,\n", COLOR_GRN, COLOR_BLK);
  putstr("but a problem with us not remapping the timer IRQ from the PIC,\n", COLOR_GRN, COLOR_BLK);
  putstr("so it shows up on Channel 8\n", COLOR_GRN, COLOR_BLK);
  return 0;
}
