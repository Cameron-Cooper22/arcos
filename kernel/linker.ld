ENTRY(_start);

SECTIONS {
  . = 0x8200;

  .startup : {
    _start = .;
    *(.startup)
  }

  .text : {
    *(.text) 
  }

  .rodata (READONLY) : {
    *(.rodata) 
  }

  .data : { 
    *(.data) 
  }

  .bss : {
    *(COMMON)
    *(.bss) 
  }
}
