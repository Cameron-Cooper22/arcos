/**
 * This is a linker script for the nrf52840 SoC
 * to be used with the bootloader. For now this
 * will be the only supported chip, however as
 * I move out of this and go into college I
 * plan on adding more devices.
 */

#define __LD_FLASH_START 0x00000000
#define __LD_FLASH_SIZE 0x00100000

#define __LD_RAM_START 0x20000000
#define __LD_RAM_SIZE 0x00040000

#define __LD_BOOT_STACK_SIZE 0x00000800

#define __LD_RAM0_START __LD_RAM_START
#define __LD_RAM0_SIZE 0x00000100

#define __LD_CRASH_REPORT_RAM_START (__LD_RAM0_START + __LD_RAM0_SIZE)
#define __LD_CRASH_REPORT_RAM_SIZE 0x00000100

#define __LD_RAM1_START (__LD_CRASH_REPORT_RAM_START + __LD_CRASH_REPORT_RAM_SIZE)
#define __LD_RAM1_SIZE (__LD_RAM_SIZE - (__LD_RAM0_SIZE + __LD_CRASH_REPORT_RAM_SIZE))

MEMORY
{
  FLASH (rx)	: ORIGIN = __LD_FLASH_START, LENGTH = __LD_FLASH_SIZE
  /* specially allocated ram for NVIC */
  RAM_NVIM (rwx): ORIGIN = __LD_RAM0_START, LENGTH = __LD_RAM0_SIZE
  RAM_CRASH_DATA (rwx) : ORIGIN = __LD_CRASH_REPORT_RAM_START, LENGTH = __LD_CRASH_REPORT_RAM_SIZE
  RAM (rwx) 	: ORIGIN = __LD_RAM1_START, LENGTH = __LD_RAM1_SIZE
}

OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")

/* https://developer.arm.com/documentation/100166/0001/Nested-Vectored-Interrupt-Controller/NVIC-programmers-model/Table-of-NVIC-registers https://developer.arm.com/documentation/107565/0101/Use-case-examples/Generic-Information/What-is-inside-a-program-image-/Vector-table */

/**
 * Script to place various sections and symbols
 * that various pieces of code needs, such as 
 * HEAP/STACK limits
 */

ENTRY(Reset_Handler) /* entrance to code, calls inits before entering __start() */

SECTIONS
{
  .text :
  {
    KEEP(*(.Vectors))
    *(.text*)

    KEEP(*(.init))
    KEEP(*(.fini))

    /* .ctors */
    *crtbegin.o(.ctors)
    *crtbegin?.o(.ctors)
    *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
    *(SORT(.ctors.*))
    *(.ctors)

    /* .dtors */
    *crtbegin.o(.dtors)
    *crtbegin?.o(.dtors)
    *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
    *(SORT(.dtors.*))
    *(.dtors)

    *(.rodata*)
    
    /* exception frame */
    KEEP(*(.eh_frame*))
  } > FLASH

  .sdh_soc_observers :
  {
    PROVIDE(__start_sdh_soc_observers = .);
    KEEP(*(SORT(.sdh_soc_observers*)))
    PROVIDE(__stop_sdh_soc_observers = .);
  } > FLASH
  
  .sdh_stack_observers :
  {
    PROVIDE(__start_sdh_stack_observers = .);
    KEEP(*(SORT(.sdh_stack_observers*)))
    PROVIDE(__stop_sdh_stack_observers = .);
  } > FLASH

  .sdh_req_observers :
  {
    PROVIDE(__start_sdh_req_observers = .);
    KEEP(*(SORT(.sdh_req_observers*)))
    PROVIDE(__stop_sdh_req_observers = .);
  } > FLASH

  .sdh_state_observers :
  {
    PROVIDE(__start_sdh_state_observers = .);
    KEEP(*(SORT(.sdh_state_observers*)))
    PROVIDE(__stop_sdh_state_observers = .);
  } > FLASH
  
  .sdh_ble_observers :
  {
    PROVIDE(__start_sdh_ble_observers = .);
    KEEP(*(SORT(.sdh_ble_observers*)))
    PROVIDE(__stop_sdh_ble_observers = .);
  } > FLASH
  
  /* points to exception table */
  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > FLASH

  __exidx_start = .;
  .ARM.exidx :
  {
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
  } > FLASH
  __exidx_end = .;

  __etext = .;

  .data : AT (__etext)
  {
    __data_start = .;
    *(vtable)
    *(.data*)

    . = ALIGN(8);
    /* preinit data */
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP(*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);

    . = ALIGN(8);
    /* init data */
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP(*(SORT(.init_array.*)))
    KEEP(*(.init_array))
    PROVIDE_HIDDEN (__init_array_end = .);


    . = ALIGN(8);
    /* finit data */
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP(*(SORT(.fini_array.*)))
    KEEP(*(.fini_array))
    PROVIDE_HIDDEN (__fini_array_end = .);

    . = ALIGN(8);
    PROVIDE(__start_fs_data = .);
    KEEP(*(.fs_data))
    PROVIDE(__stop_fs_data = .);

    *(.jcr)
    . = ALIGN(8);
    /* All data end */
    __data_end__ = .;
  } > RAM

  __edata = .;
  
  /* not loaded @ runtime */
  .nvictable (NOLOAD) :
  {
    PROVIDE(__start_nvictable = .);
    KEEP(*(.nvictable))
    PROVIDE(__stop_nvictable = .);
  } > RAM_NVIC

  .crash_data_ram :
  {
    . = ALIGN(8);
    __CRASH_DATA_RAM__ = .; 
    __CRASH_DATA_RAM_START__ = .; /* creates glob symbol @ data start */
    KEEP(*(.keep.crash_data_ram))
    *(.m_crash_data_ram) /* user def section */
    . += __LD_CRASH_DATA_REPORT_RAM_SIZE;
    . = ALIGN(8);
    __CRASH_DATA_RAM_END__ = .; /* defines glob symbol @ data end */
  } > RAM_CRASH_DATA

  .no_init (NOLOAD) :
  {
    PROVIDE(__start_noinit = .);
    KEEP(*(.noinit))
    PROVIDE(__stop_noinit = .);
  } > RAM

  .bss :
  {
    . = ALIGN(8);
    __bss_start__ = .;
    *(.bss*)
    *(COMMON)
    . = ALIGN(8);
    __bss_end__ = .;
  } > RAM

  /* honest to god this probably isnt even necessary, dunno
   * where dynamic memory alloc would be needed but hey
   * why not
   */
  .heap (NOLOAD):
  {
    __end__ = .;
    end = __end__;
    *(.heap*);

    /* expand to stack limit */
    ASSERT(. <= (ORIGIN(RAM) + LENGTH(RAM) - __LD_BOOT_STACK_SIZE), "heap region overflowed into stack");
    . = ORIGIN(RAM) + LENGTH(RAM) - __LD_BOOT_STACK_SIZE;
    __HeapLimit = .;
  } > RAM

  PROVIDE(__heap_start = ADDR(.heap));
  PROVIDE(__heap_size = SIZEOF(.heap));
  PROVIDE(__arcos_sbrk_start = ADDR(.heap));
  PROVIDE(__arcos_krbs_start = ADDR(.heap) + SIZEOF(.heap));

  /**
   * does not contain any symbols, only used for
   * linker script calculating the size of stack
   * sections and later assigning values to 
   * stack symbols
   */
  .stack (NOLOAD) :
  {
    __StackLimit = .;
    *(.stack*)
    /* puts the stack at the end of ram */
    . = ORIGIN(RAM) + LENGTH(RAM);
  } > RAM

  __StackTop = ORIGIN(RAM) + LENGTH(RAM);
  __StackLimit = __StackTop - __LD_BOOT_STACK_SIZE;
  PROVIDE(__stack = __StackTop);

}
