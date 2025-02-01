#!/bin/sh

mkdir -p ../../dist/x86_64
cp dist/x86_64/arcos.bin targets/x86_64/iso/boot/arcos.bin
grub-mkrescue /usr/lib/grub/i386-pc -o ../../dist/x86_64/kernel.iso targets/x86_64/iso
