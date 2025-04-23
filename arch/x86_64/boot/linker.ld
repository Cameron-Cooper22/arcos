ENTRY(_start)

KERNEL_LMA = 1M;
KERNEL_VMA = 0xffffffff80000000;

SECTIONS
{
  . = KERNEL_LMA + KERNEL_VMA;
  _kernel_start = .;
  .text : AT(ADDR(.text) - KERNEL_VMA) {
    *(.multiboot)
    *(.text)
  }

  .rodata : AT(ADDR(.rodata) - KERNEL_VMA) {
    *(.rodata*)
  }

  .data : AT(ADDR(.data) - KERNEL_VMA) {
    *(.data)
  }
  
  .bss : AT(ADDR(.bss) - KERNEL_VMA) {
    *(COMMON)
    *(.bss*)
  }

  _kernel_end = .;
}
