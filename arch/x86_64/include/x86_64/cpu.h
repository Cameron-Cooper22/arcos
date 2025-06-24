#ifndef __ARCOS_X86_64_CPU
#define __ARCOS_X86_64_CPU

#include <stdint.h>
#define COM1_PORT	0x03f8

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

// TODO: Test to check if this is valid
static inline void inb_dest(uint16_t port, uint8_t* dest) {
    __asm__ volatile ("inb %1, %0" : "=m"(*dest) : "Nd"(port));
}


#endif
