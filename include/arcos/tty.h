#ifndef __ARCOS_TTY
#define __ARCOS_TTY

#include <stddef.h>

// currently vga is just the terminal, but once
// a true terminal is implemented this will change.
void terminal_init(void);
void terminal_putchar(char c);
// buffered write to tty
void terminal_write(const char* data, size_t len);
void terminal_writestr(const char* data);

#endif
