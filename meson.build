project('arcos', 'c', 'rust', version: '0.1.0',
  default_options: ['c_std=c23', 'rust_std=2021'])

rust = meson.get_compiler('rust')

x86_64_asm_srcs = [
  'arch/x86_64/bootseq/header.asm',
  'arch/x86_64/bootseq/lm.asm',
  'arch/x86_64/bootseq/boot.asm'
]

x86_64_ld_script = files('arch/x86_64/linker.ld')

nasm = find_program('nasm')

x86_64_asm_gen = generator(nasm,
  output: '@BASENAME@.o',
  arguments: ['-felf64', '@INPUT@', '-o', '@OUTPUT@'])

x86_64_asm_gen_objs = x86_64_asm_gen.process(x86_64_asm_srcs)

kerneldirs = include_directories('include')
libcincdir = include_directories('libc/include')

# this will generate rust libraries
# subdir('rust')

subdir('kernel')

# option('target_arch', type: 'string', value: 'x86_64', description: 'Target for the x86_64 architecture')

x86_64_kernel = executable(
  'arcos.bin', x86_64_asm_gen_objs, asm_gen_objs, kernel_sources,
  c_args: ['-mcmodel=kernel', '-Wall', '-Wextra', '-fno-exceptions', '-fno-rtti'],
  link_args: ['-no-pie', '-mcmodel=kernel', '-masm=intel', '-v', '-lgcc', '-T', '../arch/x86_64/linker.ld'], # ../arch/x86_64/linker.ld bc this runs within a build dir
  link_depends: x86_64_ld_script,
  include_directories: [kerneldirs, libcincdir]
)

grub_file = files('targets/x86_64/iso/boot/grub/grub.cfg')
iso_builder = find_program('build-x86_64-iso.make')
iso_gen = custom_target('build-iso',
  output: ['arcos.iso'],
  command: ['make', '-f', iso_builder],
  build_by_default: true,
  depends: [x86_64_kernel],
  depend_files: 'targets/x86_64/iso/boot/grub/grub.cfg'
)
