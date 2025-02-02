kernel_kernel_hardware_asm_srcs = ['isr_defs.asm']
kernel_kernel_hardware_srcs = ['kernel/kernel/hardware/interrupts.c']

nasm = find_program('nasm')

asm_gen = generator(nasm,
  output: '@BASENAME@.o',
  arguments: ['-felf64', '@INPUT@', '-o', '@OUTPUT@'])

asm_gen_objs = asm_gen.process(kernel_kernel_hardware_asm_srcs)
