;
; The GDT
;
; boot.asm
;

; Set Program Origin
[org 0x7C00]

; 16-bit Mode
[bits 16]

; Initialize the base pointer and the stack pointer
; The initial values should be fine for what we've done so far,
; but it's better to do it explicitly
mov bp, 0x0500
mov sp, bp

; Before we do anything else, we want to save the ID of the boot
; drive, which the BIOS stores in register dl. We can offload this
; to a specific location in memory
mov byte[boot_drive], dl

mov bx, msg_hello_world
call print_bios

; Load the next sector

; The first sector's already been loaded, so we start with the second sector
; of the drive. Note: Only bl will be used
mov bx, 0x0002

; We only want to load one sector from the disk for now. This will
; be higher later. Note: Only cl will be used
mov cx, 0x0001

; Finally, we want to store the new sector immediately after the first
; loaded sector, at adress 0x7E00. This will help a lot with jumping between
; different sectors of the bootloader.
mov dx, 0x7E00

call load_bios

; To 32-bit
call elevate_bios

bootsector_hold:
  jmp $

%include "real_mode/print.asm"
%include "real_mode/print_hex.asm"
%include "real_mode/load.asm"
%include "real_mode/gdt.asm"
%include "real_mode/elevate.asm"

msg_hello_world:                db `\r\nHello World, from the BIOS!\r\n`, 0

boot_drive:                     db 0x00

times 510 - ($ - $$) db 0x00

dw 0xAA55

bootsector_extended:
begin_protected:

  call clear_protected

  call detect_lm_protected

  mov esi, protected_alert
  call print_protected

  jmp $

%include "protected_mode/clear.asm"
%include "protected_mode/print.asm"
%include "protected_mode/detect_lm.asm"
%include "protected_mode/init_pt.asm"

vga_start:		equ 0x000b8000
vga_extent:		equ 80 * 25 * 2	; 80 (w) * 25 (h) * 2 (bytes)
kernel_start:		equ 0x00100000
style_wb:		equ 0x0f

protected_alert:                 db `64-bit long mode supported`, 0

times 512 - ($ - bootsector_extended) db 0x00
long_mode_init:



times 512 - ($ - long_mode_init) db 0x00
