#ifndef __ARCOS_X86_64_MB2_HEADER
#define __ARCOS_X86_64_MB2_HEADER

#define MB_SEARCH	0x8000
#define MB_HEADER_ALIGN	8
#define MB2_HEADER_MAGIC 	0xe85250d6
#define MB2_BOOTLOADER_MAGIC	0x36d76289
#define MB_MOD_ALIGN 	0x1000
#define MB_INFO_ALIGN	0x1000

#define MB_TAG_ALIGN			8
#define MB_TAG_TYPE_END			0
#define MB_TAG_TYPE_CMDLINE 		1
#define MB_TAG_TYPE_BOOT_LOADER_NAME 	2
#define MB_TAG_TYPE_MODULE 		3
#define MB_TAG_TYPE_BASIC_MEMINFO	4
#define MB_TAG_TYPE_BOOTDEV		5
#define MB_TAG_TYPE_MMAP		6
#define MB_TAG_TYPE_VBE			7
#define MB_TAG_TYPE_FRAMEBUFFER 	8
#define MB_TAG_TYPE_ELF_SECTIONS	9
#define MB_TAG_TYPE_APM			10
#define MB_TAG_TYPE_EFI32		11
#define MB_TAG_TYPE_EFI64		12
#define MB_TAG_TYPE_SMBIOS		13
#define MB_TAG_TYPE_ACPI_OLD		14
#define MB_TAG_TYPE_ACPI_NEW		15
#define MB_TAG_TYPE_NETWORK		16
#define MB_TAG_TYPE_EFI_MMAP		17
#define MB_TAG_TYPE_EFI_BS		18
#define MB_TAG_TYPE_EFI32_IH		19
#define MB_TAG_TYPE_EFI64_IH		20
#define MB_TAG_TYPE_LOAD_BASE_ADDR	21

// NOTE: holy fuck this hurts my fingers

#define MULTIBOOT_HEADER_TAG_END	0
#define MULTIBOOT_HEADER_TAG_INFORMATION_REQUEST	1
#define MULTIBOOT_HEADER_TAG_ADDRESS			2
#define MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS		3
#define MULTIBOOT_HEADER_TAG_CONSOLE_FLAGS		4
#define MULTIBOOT_HEADER_TAG_FRAMEBUFFER		5
#define MULTIBOOT_HEADER_TAG_MODULE_ALIGN		6
#define MULTIBOOT_HEADER_TAG_EFI_BS			7
#define MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS_EFI32	8
#define MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS_EFI64	9
#define MULTIBOOT_HEADER_TAG_RELOCATABLE		10

#define MULTIBOOT_ARCHITECTURE_I386	0
#define MULTIBOOT_ARCHITECTURE_MIPS32	4
#define MULTIBOOT_HEADER_TAG_OPTIONAL	1

#define MULTIBOOT_LOAD_PREFERENCE_NONE 	0
#define MULTIBOOT_LOAD_PREFERENCE_LOW	0
#define MULTIBOOT_LOAD_PREFERENCE_HIGH	0

#define MULTIBOOT_CONSOLE_FLAGS_CONSOLE_REQUIRED 	1
#define MULTIBOOT_CONSOLE_FLAGS_EGA_TEXT_SUPPORTED 	2

#ifndef ASM_FILE

typedef unsigned char		multiboot_uint8_t;
typedef unsigned short 		multiboot_uint16_t;
typedef unsigned int 		multiboot_uint32_t;
typedef unsigned long long 	multiboot_uint64_t;

struct multiboot_header_t {
  multiboot_uint32_t magic;
  multiboot_uint32_t architecture;
  multiboot_uint32_t header_length;
  multiboot_uint32_t checksum;
};

struct multiboot_header_tag_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
};

struct multiboot_header_tag_information_request_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
  multiboot_uint32_t requests[0];
};

struct multiboot_header_tag_address_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
  multiboot_uint32_t header_addr;
  multiboot_uint32_t load_addr;
  multiboot_uint32_t load_end_addr;
  multiboot_uint32_t bss_end_addr;
};

struct multiboot_header_tag_entry_address_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
  multiboot_uint32_t entry_addr;
};

struct multiboot_header_tag_console_flags_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
  multiboot_uint32_t console_flags;
};

struct multiboot_header_tag_framebuffer_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
  multiboot_uint32_t width;
  multiboot_uint32_t height;
  multiboot_uint32_t depth;
};

struct multiboot_header_tag_module_align_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
};

struct multiboot_header_tag_relocatable_t {
  multiboot_uint16_t type;
  multiboot_uint16_t flags;
  multiboot_uint32_t size;
  multiboot_uint32_t min_addr;
  multiboot_uint32_t max_addr;
  multiboot_uint32_t align;
  multiboot_uint32_t preference;
};

struct multiboot_color_t {
  multiboot_uint8_t red;
  multiboot_uint8_t green;
  multiboot_uint8_t blue;
};

typedef struct multiboot_mmap_entry_t {
  multiboot_uint64_t addr;
  multiboot_uint64_t len;
#define MULTIBOOT_MEMORY_AVAILABLE		1
#define MULTIBOOT_MEMORY_RESERVED		2
#define MULTIBOOT_MEMORY_ACPI_RECLAIMABLE	3
#define MULTIBOOT_MEMORY_NVS			4
#define MULTIBOOT_MEMORY_BADRAM			5
  multiboot_uint32_t type;
  multiboot_uint32_t zero;
} multiboot_mmap_entry_t;

struct multiboot_tag_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
};

struct multiboot_tag_string_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  char string[0];
};

struct multiboot_tag_module_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t mod_start;
  multiboot_uint32_t mod_end;
  char cmdline[0];
};

struct multiboot_tag_basic_meminfo_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t mem_lower;
  multiboot_uint32_t mem_upper;
};

struct multiboot_tag_bootdev_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t biosdev;
  multiboot_uint32_t slice;
  multiboot_uint32_t part;
};

struct multiboot_tag_mmap_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t entry_size;
  multiboot_uint32_t entry_version;
  struct multiboot_mmap_entry_t entries[0];  
};

struct multiboot_vbe_info_block_t {
  multiboot_uint8_t external_specification[512];
};

struct multiboot_vbe_mode_info_block_t {
  multiboot_uint8_t external_specification[256];
};

struct multiboot_tag_vbe_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;

  multiboot_uint16_t vbe_mode;
  multiboot_uint16_t vbe_interface_seg;
  multiboot_uint16_t vbe_interface_off;
  multiboot_uint16_t vbe_interface_len;

  struct multiboot_vbe_info_block_t vbe_control_info;
  struct multiboot_vbe_mode_info_block_t vbe_mode_info;
};

struct multiboot_tag_framebuffer_common_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;

  multiboot_uint64_t framebuffer_addr;
  multiboot_uint32_t framebuffer_pitch;
  multiboot_uint32_t framebuffer_width;
  multiboot_uint32_t framebuffer_height;
  multiboot_uint8_t framebuffer_bpp;
#define MULTIBOOT_FRAMEBUFFER_TYPE_INDEXED 0
#define MULTIBOOT_FRAMEBUFFER_TYPE_RGB     1
#define MULTIBOOT_FRAMEBUFFER_TYPE_EGA_TEXT     2
  multiboot_uint8_t framebuffer_type;
  multiboot_uint16_t reserved;
};

struct multiboot_tag_framebuffer_t {
  struct multiboot_tag_framebuffer_common_t common;

  union {
    struct {
      multiboot_uint16_t framebuffer_palette_num_colors;
      struct multiboot_color_t framebuffer_palette[0];
    };
    struct {
      multiboot_uint8_t framebuffer_red_field_position;
      multiboot_uint8_t framebuffer_red_mask_size;
      multiboot_uint8_t framebuffer_green_field_position;
      multiboot_uint8_t framebuffer_green_mask_size;
      multiboot_uint8_t framebuffer_blue_field_position;
      multiboot_uint8_t framebuffer_blue_mask_size;
    };
  };
};

struct multiboot_tag_elf_sections_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t num;
  multiboot_uint32_t entsize;
  multiboot_uint32_t shndx;
  char sections[0];
};

struct multiboot_tag_apm_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint16_t version;
  multiboot_uint16_t cseg;
  multiboot_uint32_t offset;
  multiboot_uint16_t cseg_16;
  multiboot_uint16_t dseg;
  multiboot_uint16_t flags;
  multiboot_uint16_t cseg_len;
  multiboot_uint16_t cseg_16_len;
  multiboot_uint16_t dseg_len;
};

struct multiboot_tag_efi32_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t pointer;
};

struct multiboot_tag_efi64_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint64_t pointer;
};

struct multiboot_tag_smbios_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint8_t major;
  multiboot_uint8_t minor;
  multiboot_uint8_t reserved[6];
  multiboot_uint8_t tables[0];
};

struct multiboot_tag_old_acpi_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint8_t rsdp[0];
};

struct multiboot_tag_new_acpi_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint8_t rsdp[0];
};

struct multiboot_tag_network_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint8_t dhcpack[0];
};

struct multiboot_tag_efi_mmap_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t descr_size;
  multiboot_uint32_t descr_vers;
  multiboot_uint8_t efi_mmap[0];
}; 

struct multiboot_tag_efi32_ih_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t pointer;
};

struct multiboot_tag_efi64_ih_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint64_t pointer;
};

struct multiboot_tag_load_base_addr_t {
  multiboot_uint32_t type;
  multiboot_uint32_t size;
  multiboot_uint32_t load_base_addr;
};

#endif
#endif
