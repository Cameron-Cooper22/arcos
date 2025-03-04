  MB2_MAGIC	equ 0xe85250d6
  MB2_ARCH	equ 0
  MB2_HEADER_LENGTH equ (multiboot2_header_end - multiboot2_header_start)

  section .multiboot_header
multiboot2_header_start:
  dd MB2_MAGIC
  dd MB2_ARCH
  dd MB2_HEADER_LENGTH
  dd -(MB2_MAGIC + MB2_ARCH + MB2_HEADER_LENGTH)
  ; add optional tags, stuff for framebuffer or entry address
  dw 0
  dw 0
  dd 8
multiboot2_header_end:
