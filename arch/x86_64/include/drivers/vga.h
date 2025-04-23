#ifndef __ARCOS_X86_64_DRIVERS_VGA_H
#define __ARCOS_X86_64_DRIVERS_VGA_H

#define VGA_MEMORY P2V(0xb8000)

void vga_init();
void vga_write(char c);

#endif
