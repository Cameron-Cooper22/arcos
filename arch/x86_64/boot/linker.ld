ENTRY(_start)

KERNEL_LMA = 1M;
KERNEL_VMA = 0xffffffff80000000;

SECTIONS {
  . = KERNEL_LMA;
  . += KERNEL_VMA;
  _kernel_start = .;
  .multiboot : {
    *(.multiboot*)
  }
  .text ALIGN (4K) : AT(ADDR(.text) - KERNEL_VMA) {
    *(.text*)
  }
  .rodata ALIGN (4K) : AT (ADDR(.rodata) - KERNEL_VMA) {
    *(.rodata*)
  }
  .data ALIGN(4K): AT(ADDR(.data) - KERNEL_VMA) {
    *(.data*)
  }
  .bss ALIGN(4K) : AT(ADDR(.bss) - KERNEL_VMA){
    *(COMMON)
    *(.bss*)
    *(.bootstrap_stack)
  }

  /DISCARD/ : { *(.eh_frame) }
  _kernel_end = .;
}
