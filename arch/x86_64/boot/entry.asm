  extern lm_start
  global _start
  section .text
  [bits 32]
_start:
  mov esp, stack_top
  
  call check_mb
  call check_cpuid
  call check_lm

  call setup_pt
  call enable_paging

  lgdt [gdt64.pointer]
  jmp gdt64.code_segment:lm_start

  hlt

check_mb:
  cmp eax, 0x36d76289
  jne .no_mb
  ret
.no_mb:
  mov al, "M"
  jmp error

check_cpuid:
  pushfd
  pop eax
  mov ecx, eax
  xor eax, 1 << 21
  push eax
  popfd
  pushfd
  pop eax
  push ecx
  popfd
  cmp eax, ecx
  je .no_cpuid
  ret
.no_cpuid:
  mov al, "C",
  jmp error

check_lm:
  mov eax, 0x80000000
  cpuid
  cmp eax, 0x80000001

  jb .no_lm

  mov eax, 0x80000001
  cpuid
  test edx, 1 << 29
  jz .no_lm

  ret
.no_lm:
  mov al, "L"
  jmp error

setup_pt:
  mov eax, pt_l3
  or eax, 0b11 ;pres, writ
  mov [pt_l4], eax

  mov eax, pt_l2
  or eax, 0b11
  mov [pt_l3], eax

  mov ecx, 0

.loop:
  mov eax, 0x200000
  mul ecx
  or eax, 0b10000011
  mov [pt_l2 + ecx * 8], eax

  inc ecx
  cmp ecx, 512
  jne .loop

  ret

enable_paging:
  mov eax, pt_l4
  mov cr3, eax

  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  mov ecx, 0xc0000080
  rdmsr
  or eax, 1 << 8
  wrmsr
  mov eax, cr0
  or eax, 1 << 31
  mov cr0, eax

  ret

error:
  mov dword [0xb8000], 0x4f524f45
  mov dword [0xb8004], 0x4f3a4f52
  mov dword [0xb8008], 0x4f204f20
  mov byte  [0xb800a], al

  hlt

section .bss	; static
align 4096
pt_l4:
  resb 4096
pt_l3:
  resb 4096
pt_l2:
  resb 4096
stack_bottom:
  resb 4096 * 4 ; 16 KB
stack_top:


section .rodata
gdt64:
  dq 0
.code_segment: equ $ - gdt64
  dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.pointer:
  dw $ - gdt64 - 1
  dq gdt64
