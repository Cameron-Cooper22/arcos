x86_64_asm_src_files := $(shell find arch/x86_64/bootseq -name "*.s")
x86_64_asm_obj_files := $(patsubst arch/x86_64/bootseq/%.s, build/x86_64/%.o, $(x86_64_asm_src_files))

kernel_c_src_files := $(shell find kernel/ -name "*.c")
kernel_c_obj_files := $(patsubst kernel/%.c, build/x86_64/%.o, $(x86_64_c_src_files))

x86_64_obj_files := $(kernel_c_obj_files) $(x86_64_asm_obj_files)

$(kernel_c_obj_files): build/x86_64/%.o : kernel/%.c
	mkdir -p $(dir $@) && \
	x86_64-elf-gcc -c -Iinclude -Ilibc/include -ffreestanding $(patsubst build/x86_64/%.o, kernel/%.c, $@) -o $@

$(x86_64_asm_obj_files): build/x86_64/%.o : arch/x86_64/bootseq/%.s
	mkdir -p $(dir $@) && \
	x86_64-elf-as $(patsubst build/x86_64/%.o, arch/x86_64/bootseq/%.s, $@) -o $@

.PHONY: build-x86_64
build-x86_64: $(x86_64_asm_obj_files) $(kernel_c_obj_files)
	mkdir -p dist/x86_64 && \
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T arch/x86_64/linker.ld $(kernel_object_files) $(x86_64_asm_obj_files) && \
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso

