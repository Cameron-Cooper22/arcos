CC=x86_64-elf-gcc
LD=x86_64-elf-ld
AS=nasm

BOOT_x86_64_ASM_SRC := $(shell find arch/x86_64/boot/ -name *.asm)
BOOT_x86_64_ASM_OBJS := $(patsubst arch/x86_64/boot/%.asm, build/x86_64/%.o, $(BOOT_x86_64_ASM_SRC))

KERNEL_C_SRC:=$(shell find kernel -name *.c)
KERNEL_C_OBJS:=$(patsubst kernel/%.c, build/x86_64/%.o, $(KERNEL_C_SRC))

BASE_CC_FLAGS=-c -ffreestanding -Wall -pedantic -Wextra -Iinclude -Ilibc/include -nostdlib 
BASE_AS_FLAGS=-f elf64
BASE_LD_FLAGS=-n -o

OBJS := ${KERNEL_C_OBJS} ${BOOT_x86_64_ASM_OBJS}

$(BOOT_x86_64_ASM_OBJS): build/x86_64/%.o : arch/x86_64/boot/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/x86_64/%.o, arch/x86_64/boot/%.asm, $@) -o $@

$(KERNEL_C_OBJS): build/x86_64/%.o : kernel/%.c
	mkdir -p $(dir $@) && \
	${CC} $(patsubst build/x86_64/%.o, kernel/%.c, $@) ${BASE_CC_FLAGS} -o $@

.PHONY: clean build
build: $(OBJS)
	mkdir -p dist/x86_64 && \
	${LD} -n -o dist/x86_64/kernel.bin -T arch/x86_64/boot/linker.ld $(OBJS) && \
	cp dist/x86_64/kernel.bin arch/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso arch/x86_64/iso

clean:
	rm $(shell find ./ -name '*.iso')
	rm $(shell find ./build -name '*.o')
	rm $(shell find ./ -name '*.bin')
