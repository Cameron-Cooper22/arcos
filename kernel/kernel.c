#include <memory.h>
#include <stdint.h>
#include <arch/debug.h> // for 

// TODO: This is a test
void clear_screen() {
    uintptr_t *vga_mem = (unsigned long *)P2V(0xb8000);
    for (int i = 0; i < 80 * 24 * 2; i++) *vga_mem++ = 0;
}

void print_string(char* str) {
    uintptr_t *vga_mem = (uintptr_t *)P2V(0xb8000);
    while (*str) {
	*vga_mem++ = *str++;
      	*vga_mem++ = 0x7;	// 0b0111
    }
}

void kmain() {
    // for now, just debug via serial
    qemu_exit();
    print_string("Welcome home. Praise be to the all knowing kernel");
    for (;;);

}
