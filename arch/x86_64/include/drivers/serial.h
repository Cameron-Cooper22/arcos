#ifndef __ARCOS_x86_64_DRIVER_SERIAL_H
#define __ARCOS_x86_64_DRIVER_SERIAL_H

#include <stdint.h>

#define PORT_COM1 0x3f8

void serial_init(uint16_t port);
void serial_write(uint16_t port, uint8_t c); // TODO: Check whether I should use u8 or char

#endif
