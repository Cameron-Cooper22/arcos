project('arcos', ['c', 'rust', 'asm'],
  default_options: [
    'buildtype=debugoptimized',
    'warning_level=1'
  ]
)

linker_script = linker.ld

kernel_elf = executable('kernel.elf', [boot_asm, kernel_c, rust_lib], 
    install: false,
    override_options: ['b_lto=false'],  # no LTO across languages
    link_args: ['-T', linker_script, '-nostdlib', '-ffreestanding'])
