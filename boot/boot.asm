[org 0x7c00]

jmp begin_real

kernel_size db 0

begin_real:
  bits 16

  mov bp, 0x0500
  mov sp, bp

  mov byte[boot_drive], dl

  mov bx, 0x0002

  mov cx, [kernel_size]
  add cx, 2

  mov dx, 0x7e00
  
  call load_bios

  call elevate_bios

bootsector_hold:
  jmp $

%include "real_mode/print.asm"
%include "real_mode/print_hex.asm"
%include "real_mode/load.asm"
%include "real_mode/gdt.asm"
%include "real_mode/elevate.asm"

boot_drive:		db 0x00

times 510 - ($ - $$) db 0x00

dw 0xaa55

bootsector_extended:
begin_protected:

  bits 32

  call clear_protected

  call detect_lm_protected

  call init_pt_protected

  call elevate_protected

  jmp $

%include "protected_mode/clear.asm"
%include "protected_mode/print.asm"
%include "protected_mode/detect_lm.asm"
%include "protected_mode/init_pt.asm"
%include "protected_mode/gdt.asm"
%include "protected_mode/elevate.asm"

vga_start:		equ 0x000b8000
vga_extent:		equ 80 * 25 * 2
style_wb:		equ 0x0f

times 512 - ($ - bootsector_extended) db 0x00
begin_long_mode:
  bits 64

  mov rdi, style_blue
  call clear_long
  
  mov rdi, style_blue
  mov rsi, long_mode_note
  call print_long


  call kernel_start

  jmp $

%include "long_mode/clear.asm"
%include "long_mode/print.asm"

kernel_start:                   equ 0x8200              ; Kernel is at 1MB
long_mode_note:                 db `Now running in fully-enabled, 64-bit long mode!`, 0
style_blue:                     equ 0x1F

times 512 - ($ - begin_long_mode) db 0x00
