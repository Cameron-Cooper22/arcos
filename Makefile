###############################################
################## BASE VARS ##################
###############################################
# specified 'KERNEL' because some directories should ignore some errors
WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
	     -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
	     -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
	     -Wconversion -Wstrict-prototypes

# used for creating archives WITHOUT linking.
PROJ_ROOT := $(realpath .)
PROJ_DIRS := arch kernel
BUILD_DIR := build

OS := Arcos
ARCH ?= x86_64
TARGET_TYPE ?= elf

SUPPORTED_ARCHS := x86_64

ARCH_DIR := $(PROJ_ROOT)/arch/$(ARCH)
ARCH_INCDIR := $(ARCH_DIR)/include
ARCH_S_SRCFILES := $(shell find $(ARCH_DIR) -type f -name "*.S")
ARCH_C_SRCFILES := $(shell find $(ARCH_DIR) -type f -name "*.c")
ARCH_SRCFILES := $(ARCH_S_SRCFILES) $(ARCH_C_SRCFILES)
ARCH_OBJFILES := $(patsubst $(PROJ_ROOT)/arch/$(ARCH)/%.c,$(PROJ_ROOT)/$(BUILD_DIR)/arch/$(ARCH)/%.o,$(ARCH_C_SRCFILES)) \
		 $(patsubst $(PROJ_ROOT)/arch/$(ARCH)/%.S,$(PROJ_ROOT)/$(BUILD_DIR)/arch/$(ARCH)/%.o,$(ARCH_S_SRCFILES))
ARCH_DEPFILES := $(patsubst %.c,%.o,$(ARCH_SRCFILES)) $(patsubst %.S,%.o,$(ARCH_SRCFILES))
ARCH_CFLAGS := -I$(ARCH_INCDIR)

KERNEL_DIR := $(PROJ_ROOT)/kernel
KERNEL_S_SRCFILES := $(shell find $(KERNEL_DIR) -type f -name "*.S")
KERNEL_C_SRCFILES := $(shell find $(KERNEL_DIR) -type f -name "*.c")
KERNEL_SRCFILES := $(KERNEL_S_SRCFILES) $(KERNEL_C_SRCFILES)
KERNEL_OBJFILES := $(patsubst $(PROJ_ROOT)/%.c,$(PROJ_ROOT)/$(BUILD_DIR)/%.o,$(KERNEL_C_SRCFILES)) \
		   $(patsubst $(PROJ_ROOT)/%.S,$(PROJ_ROOT)/$(BUILD_DIR)/%.o,$(KERNEL_S_SRCFILES))
KERNEL_DEPFILES := $(patsubst %.c,%.o,$(KERNEL_SRCFILES)) $(patsubst %.S,%.o,$(KERNEL_SRCFILES))

ARCOS_SRCFILES := $(ARCH_SRCFILES) $(KERNEL_SRCFILES)
ARCOS_OBJFILES := $(ARCH_OBJFILES) $(KERNEL_OBJFILES)
ARCOS_DEPFILES := $(ARCH_DEPFILES) $(KERNEL_DEPFILES)

GLOBAL_ARFLAGS := rc
GLOBAL_CFLAGS  := $(WARNINGS) -I$(PROJ_ROOT)/include -I$(PROJ_ROOT)/arch/include -g -std=gnu99 -nostdlib -ffreestanding -fno-exceptions -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -mcmodel=kernel -O0
GLOBAL_LDFLAGS := 

CC := $(ARCH)-$(TARGET_TYPE)-gcc
AR := $(ARCH)-$(TARGET_TYPE)-ar
AS := $(ARCH)-$(TARGET_TYPE)-as
LD := $(ARCH)-$(TARGET_TYPE)-ld
OBJCOPY := $(ARCH)-$(TARGET_TYPE)-objcopy

###############################################
################# CONDITIONALS ################
###############################################
ifeq ($(ARCH),)
	$(error ARCH is not defined. Please define an arch to target.)
endif
ifeq ($(filter $(ARCH),$(SUPPORTED_ARCHS)),)
	$(error Unsupported ARCH "$(ARCH)". Supported: $(SUPPORTED_ARCHS))
endif

###############################################
################## RECIPES ####################
###############################################
build: info arcos.iso

debug: build
	@qemu-system-x86_64 -cdrom build/arcos.iso -boot d -d int,in_asm,exec -no-reboot

run: build
	@qemu-system-x86_64 -m 512M -cdrom $(PROJ_ROOT)/$(BUILD_DIR)/arcos.iso -boot d -serial stdio -device isa-debug-exit,iobase=0xf4,iosize=0x04
	
run-gui: build
	@qemu-system-x86_64 -m 512M -cdrom $(PROJ_ROOT)/$(BUILD_DIR)/arcos.iso -boot d

arcos.iso: arcos.elf
	@echo "Building image with grub-mkrescue"
	@echo "sysroot path:	$(PROJ_ROOT)/sysroot/"
	@cp $(PROJ_ROOT)/$(BUILD_DIR)/$< $(PROJ_ROOT)/sysroot/boot/$<
	@grub-mkrescue -o $(PROJ_ROOT)/$(BUILD_DIR)/$@ $(PROJ_ROOT)/sysroot/

info:
	@echo "Project Root: $(PROJ_ROOT)"
	@echo "Building for $@"
	@echo "Using compiler $(CC)"
	@mkdir -p $(BUILD_DIR)

arcos.elf: kernel arch
	@echo "Linking $(words $(ARCOS_OBJFILES)) object files..."
	$(LD) $(GLOBAL_LDFLAGS) -T $(ARCH_DIR)/linker.ld -o $(PROJ_ROOT)/$(BUILD_DIR)/$@ $(ARCOS_OBJFILES)

kernel: $(KERNEL_OBJFILES)

arch: $(ARCH_OBJFILES)

$(PROJ_ROOT)/$(BUILD_DIR)/arch/%.o: $(PROJ_ROOT)/arch/%.c
	@mkdir -p $(dir $@)
	$(CC) $(ARCH_CFLAGS) $(GLOBAL_CFLAGS) -c $< -o $@ 

$(PROJ_ROOT)/$(BUILD_DIR)/arch/%.o: $(PROJ_ROOT)/arch/%.S
	@mkdir -p $(dir $@)
	$(CC) $(ARCH_CFLAGS) $(GLOBAL_CFLAGS) -c $< -o $@ 

$(PROJ_ROOT)/$(BUILD_DIR)/kernel/%.o: $(PROJ_ROOT)/kernel/%.c
	@mkdir -p $(dir $@)
	$(CC) $(GLOBAL_CFLAGS) -c $< -o $@ 

$(PROJ_ROOT)/$(BUILD_DIR)/kernel/%.o: $(PROJ_ROOT)/kernel/%.S
	@mkdir -p $(dir $@)
	$(CC) $(GLOBAL_CFLAGS) -c $< -o $@ 
	
clean:
	@echo "Cleaning files..."
	-@$(RM) $(ARCOS_OBJFILES)

todolist: $(ARCOS_ALLFILES)
	-@for file in $(ARCOS_SRCFILES); do fgrep --color=auto -H -e TODO -e FIXME $$file 2>/dev/null; done; true

.PHONY: clean
