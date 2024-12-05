/**
 * Extremely basic memory map. Will define secitons later.
 */

/* defaulting to no soft device for future compatibility even though
 * without a doubt i will be using soft device for AP Research
 */
#if !defined(ARCOS_FLASH_START)
  #define ARCOS_FLASH_START 0x00000000
#endif

#if !defined(ARCOS_FLASH_LEN)
  #define ARCOS_FLASH_LEN 0x00080000
#endif

#if !defined(ARCOS_RAM_START)
  #define ARCOS_RAM_START 0x20000000
  #define ARCOS_RAM_LEN 0x00010000
#endif

#if !defined(ARCOS_CONF_TARGET_BOOT_STACK_SIZE)
  #define ARCOS_CONF_TARGET_BOOT_STACK_SIZE 0x800
#endif

#define ARCOS_RAM0_START ARCOS_RAM_START
#define ARCOS_RAM0_LEN 0xe0
#define ARCOS_RAM1_START (ARCOS_RAM_START + ARCOS_RAM0_LEN)
#define ARCOS_RAM1_LEN (ARCOS_RAM_SIZE - ARCOS_RAM0_LEN)

MEMORY
{
  FLASH (rx)	: ORIGIN=ARCOS_FLASH_START, LENGTH=ARCOS_FLASH_LEN
  RAM_NVIC (rwx): ORIGIN=ARCOS_RAM0_START, LENGTH=ARCOS_RAM0_LEN
  RAM (rwx)	: ORIGIN=ARCOS_RAM1_START, LENGTH=ARCOS_RAM1_LEN
}

/* Output formats: 32-bit ELF for little arm, and bigarm */
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
