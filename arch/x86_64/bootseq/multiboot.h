#ifndef __ARCOS_MULTIBOOT
#define __ARCOS_MULTIBOOT

#define MB2_MAGIC		0xe85250d6
#define MULTIBOOT_HEADER_FLAGS 	0x00010003

#ifndef ASM
typedef unsigned char 	__u8;
typedef unsigned char      __u8;
typedef unsigned short     __u16;
typedef unsigned int       __u32;
typedef unsigned long long __u64;


/* The Multiboot header. */
struct multiboot_header {
  __u32 magic;
  __u32 flags;
  __u32 checksum;
  __u32 header_addr;
  __u32 load_addr;
  __u32 load_end_addr;
  __u32 bss_end_addr;
  __u32 entry_addr;
  __u32 mode_type;
  __u32 width;
  __u32 height;
  __u32 depth;
} __attribute__((packed, aligned(1)));



struct aout_symbol_table {
  __u32 tabsize;
  __u32 strsize;
  __u32 addr;
  __u32 reserved;
} __attribute__((packed, aligned(1)));

struct elf_section_header_table {
  __u32 num;
  __u32 size;
  __u32 addr;
  __u32 shndx;
} __attribute__((packed, aligned(1)));

struct multiboot_info {
  __u32 flags;
  __u32 mem_lower;
  __u32 mem_upper;
  __u32 boot_device;
  __u32 cmdline;
  __u32 mods_count;
  __u32 mods_addr;
  union {
    struct aout_symbol_table		aout_sym;
    struct elf_section_header_table	elf_sec;
  } u;
  __u32 mmap_length;
  __u32 mmap_addr;
  __u32 drives_length;
  __u32 drives_addr;
  __u32 config_table;

  __u32 bootloader_name;
  __u32 apm_table;

  __u32 vbe_control_info;
  __u32 vbe_mode_info;
  __u16 vbe_mode;
  __u16 vbe_interface_seq;
  __u16 vbe_interface_off;
  __u16 vbe_interface_len;
} __attribute__((packed, aligned(1)));

struct module {
  __u32 mod_start;
  __u32 mod_end;
  __u32 cmdline;
  __u32 reserved;
} __attribute__((packed, aligned(1)));

struct memory_map {
  __u32 size;
  __u64 base_addr;
  __u64 length;
  __u32 type;
} __attribute__((packed, aligned(1)));

#endif
#endif
