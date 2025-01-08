.PHONY: clean, .force-rebuild
	all: bootloader.bin

bootloader.bin: os.asm .force-rebuild
	i686-elf-as -fbin boot.s -o arcos.bin

clean: 
	rm *.bin
