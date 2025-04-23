project('arcos', ['c'],
  default_options: [
    'buildtype=debugoptimized',
    'warning_level=1'
  ]
)

c_args = ['-ffreestanding', '-m64', '-mno-red-zone', '-mcmodel=kernel',
          '-mno-mmx', '-mno-sse', '-mno-sse2']  
c_link_args = ['-nostdlib', '-static', '-z max-page-size=0x1000']  
# ^ -nostdlib: no libc/startup; -static: no dynamic linking; 
#   max-page-size=0x1000: avoid default 2MB page alignment in ld&#8203;:contentReference[oaicite:0]{index=0}.
rust_args = ['--target', 'x86_64-unknown-none', '-Ccode-model=kernel',
             '-Ctarget-feature=-mmx,-sse,-sse2', '-Cpanic=abort', '-Clinker=x86_64-elf-ld']

arch = get_option('arch')

if arch == ''
  message('Specify processor architecture in build options')
endif

inc_dir = meson.project_source_root() + '/include'

subdir('arch')
subdir('kernel')

linker_script = ld_script[0].full_path()

asm_srcs = arch_boot_asm_srcs
asm_objs = []
foreach f : asm_srcs
  obj_name = f.full_path().split('/')[-1].split('.')[0] + '.o'

  obj = custom_target(
    obj_name,
    input: f,
    output: obj_name,
    command: [cc, '-I', inc_dir, '-mcmodel=kernel', '-c', '@INPUT@', '-o', '@OUTPUT@'],
    build_by_default: true
    # Check if GCC needs capture set to true for this
  )
  asm_objs += obj

  message('Object File Generated: ' + obj_name)
endforeach

c_srcs = kernel_srcs
c_objs = []
foreach f : c_srcs
  obj_name = f.full_path().split('/')[-1].split('.')[0] + '.o'

  obj = custom_target(
    obj_name,
    input: f,
    output: obj_name,
    command: [cc , '-I', inc_dir, '-c', '-mcmodel=kernel', '@INPUT@', '-o', '@OUTPUT@'] + c_args,
    build_by_default: true
  )
  c_objs += obj

  message('Object File Generated: ' + obj_name)
endforeach

kernel_binary = executable(
  'kernel.bin',
  c_objs + asm_objs,
  link_args: ['-nostdlib', '-mcmodel=kernel', '-T', linker_script],
  install: false
)

message('Kernel Binary File created.')


# kernel_elf = executable('kernel.elf', [boot_asm, kernel_c, rust_lib], 
#     install: false,
#     override_options: ['b_lto=false'],  # no LTO across languages
#     link_args: ['-T', linker_script, '-nostdlib', '-ffreestanding'])
