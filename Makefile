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
ARCH_OBJFILES := $(patsubst $(PROJ_ROOT)/arch/%.c,$(PROJ_ROOT)/arch/$(BUILD_DIR)/%.o,$(ARCH_C_SRCFILES)) \
		 $(patsubst $(PROJ_ROOT)/%.S,$(PROJ_ROOT)/$(BUILD_DIR)/%.o,$(ARCH_S_SRCFILES))
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
GLOBAL_CFLAGS  := $(WARNINGS) -I$(PROJ_ROOT)/include -g -std=gnu99 -nostdlib -ffreestanding -fno-exceptions
GLOBAL_LDFLAGS := 

# TODO: Let the compiler(s) and binutils be changed by prefix/ARCH
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
all: arcos.elf
	@echo "Project Root: $(PROJ_ROOT)"
	@echo "Building for $@"
	@echo "Using compiler $(CC)"
	@mkdir -p $(BUILD_DIR)

arcos.elf: kernel arch
	@echo "Linking $(words $($<)) object files..."
	$(LD) $(GLOBAL_LDFLAGS) -T $(ARCH_DIR)/linker.ld -o $@ $(ARCOS_OBJFILES)

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
	-@for file in $(ARCOS_SRCFILES); do fgrep -H -e TODO -e FIXME $$file 2>/dev/null; done; true

.PHONY: clean
