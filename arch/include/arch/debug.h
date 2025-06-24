#ifndef __ARCOS_ARCH_DEBUG
#define __ARCOS_ARCH_DEBUG

void serial_init(void);

int serial_is_transmit_empty(void);

void serial_write_char(char c);

void serial_write(const char* str);

void debug_print(const char* str);

#endif
