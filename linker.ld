ENTRY(_start)

SECTIONS
{
  .text :
  {
    *(.multiboot_header)
    *(.text)
  }
}
