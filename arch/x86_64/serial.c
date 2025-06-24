#include "arch/debug.h"
#include <debug.h>
#include <x86_64/cpu.h>

void serial_init(void) {
    outb(COM1_PORT + 1, 0x00); // disable interrupts
    outb(COM1_PORT + 3, 0x80); // enable DLAB (set baud rate divisor)
    outb(COM1_PORT + 0, 0x03); // divisor = 3 (low byte) -> 38400 baud
    outb(COM1_PORT + 1, 0x00);
    outb(COM1_PORT + 3, 0x03); // 8 bit chars, no parity, one stop bit
    outb(COM1_PORT + 2, 0xc7); // enable fifo, clear, 14 byte threshold
    outb(COM1_PORT + 4, 0x0b); // IRQs enabled
}

int serial_is_transmit_empty(void) {
    return inb(COM1_PORT + 5) & 0x20;
}

void serial_write_char(char c) {
    while (!serial_is_transmit_empty());
    outb(COM1_PORT, (uint8_t) c);
}

void serial_write(const char* str) {
    for (const char* p = str; *p; p++) serial_write_char(*p);
}

void debug_print(const char *str) {
    while (*str) outb(0xe9, (uint8_t) *str++);
}
