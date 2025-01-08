bits 16

print_hex_bios:
  push ax
  push bx
  push cx

  mov ah, 0x0e

  mov al, '0'
  int 0x10
  mov al, 'x'
  int 0x10

  mov cx, 4

print_hex_bios_loop:
  cmp cx, 0
  je print_hex_bios_end

  push bx

  shr bx, 12 ; i.e 0b1101001010111010 -> 0b0000000000001101

  cmp bx, 10
  jge print_hex_bios_alpha
    
  mov al, '0'
  add al, bl

  jmp print_hex_bios_loop_end

print_hex_bios_alpha:
  sub bl, 10

  mov al, 'A'
  add al, bl

print_hex_bios_loop_end:

  int 0x10

  pop bx
  shl bx, 4

  dec cx

  jmp print_hex_bios_loop

print_hex_bios_end:
  pop cx
  pop bx
  pop ax

  ret
