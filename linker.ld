


ENTRY(_start)
SECTIONS
{
  . = KERNEL_VMA; /* not the actual bottom, -mno-red-zone shifts start addr */
  .text : AT(ADDR(.text) - KERNEL_VMA)
  {
    _code = .;
    *(.text)
    *(.rodata*)
    . = ALIGN(4096);
  }
  
  .data : AT(ADDR(.data) - KERNEL_VMA)
  {
    _data = .;
    *(.data)
    . = ALIGN(4096);
  }

  .eh_frame : AT(ADDR(.eh_fram) - KERNEL_VMA)
  {
    _ehframe = .;
    *(.eh_frame)
    . = ALIGN(4096);
  }

  .bss : AT(ADDR(.bss) - KERNEL_VMA) {
    _bss = .;
    *(.bss)

    /*
     * Usually need to include common symbols under the 
     * kernel bss section, or alternatively use -fno-common
     */
    *(COMMON)
    . = ALIGN(4096);
  }

  _end = .;

  /DISCARD/ : 
  {
    *(.comment)
  }
}
