all:
	mkdir -p ../dist/x86_64
	mv arcos.bin ../targets/x86_64/iso/boot/kernel.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o ../dist/x86_64/arcos.iso ../targets/x86_64/iso
