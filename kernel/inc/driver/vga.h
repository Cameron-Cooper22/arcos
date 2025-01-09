#ifndef __DRIVER_VGA_TEXT
#define __DRIVER_VGA_TEXT

#include <types.h>

#define VGA_START 0xb8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_EXTENT 80 * 25

#define COLOR_BLK 0
#define COLOR_BLU 1
#define COLOR_GRN 2
#define COLOR_CYN 3
#define COLOR_RED 4
#define COLOR_PRP 5
#define COLOR_BRN 6
#define COLOR_GRY 7
#define COLOR_DGY 8
#define COLOR_LBU 9
#define COLOR_LGR 10
#define COLOR_LCY 11
#define COLOR_LRD 12
#define COLOR_LPP 13  
#define COLOR_YEL 14
#define COLOR_WHT 15

#define CURSOR_PORT_COMMAND	(u16_t) 0x3d4
#define CURSOR_PORT_DATA	(u16_t) 0x3d5

typedef struct __attribute__((packed)) {
  char character;
  char style;
} vga_char;

u8_t vga_color(const u8_t fg_color, const u8_t bg_color);

void clear_win(const u8_t fg_color, const u8_t bg_color);

void putchar(const char character, const u8_t fg_color, const u8_t bg_color);

void putstr(const char *str, const u8_t fg_color, const u8_t bg_color);

u16_t get_cursor_pos();

void show_cursor();
void hide_cursor();

void advance_cursor();
void reverse_cursor();

void set_cursor_pos(u8_t x, u8_t y);

void scroll_line();

#endif
