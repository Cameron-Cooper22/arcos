.section .multiboot.data, "a"
.align 8
multiboot_header:
  .long 0xe85250d6
  .long 0
  .long multiboot_header_end - multiboot_header
  # optional flags can be put here
  # TODO: look into extra features to be requested from GRUB2
  .short 0
  .short 0
  .long 8
