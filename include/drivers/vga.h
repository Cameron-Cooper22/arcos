#ifndef __VGA_DRIVER
#define __VGA_DRIVER

#include <stdint.h>
#include <stdarg.h>

#define VGA_ROWS 25
#define VGA_COLS 80

#define __VGA_BUFFER 0xb8000

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

static uint8_t x_pos = 0;
static uint8_t y_pos = 0;

static inline uint8_t vga_entry_color(uint8_t fg, uint8_t bg);
static inline uint16_t vga_entry(unsigned char c, uint8_t color);  // puts into VGA buffer

static uint16_t* const VGA_BUFFER = (uint16_t*) 0xb8000;

static uint8_t vga_fg = VGA_COLOR_WHITE;
static uint8_t vga_bg = VGA_COLOR_BLACK;

void vga_clear(void);
void vga_clear_upper_rows(uint8_t nr);

#endif
