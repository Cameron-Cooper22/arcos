###############################################
################## BASE VARS ##################
###############################################
# specified 'KERNEL' because some directories should ignore some errors
WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
	     -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
	     -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
	     -Wconversion -Wstrict-prototypes

# used for creating archives WITHOUT linking.
AR := x86_64-elf-ar
OBJCOPY := x86_64-elf-objcopy

PROJ_ROOT := $(shell pwd)
BUILD_DIR := $(PROJ_ROOT)/build

SUPPORTED_ARCHS := x86_64

ARCH_DIR := $(PROJ_ROOT)/arch/$(ARCH)
ARCH_SRCFILES := $(shell find $(ARCH_DIR) -type f -name "*.c") $(shell find $(ARCH_DIR) -type f -name "*.S")
ARCH_OBJFILES := $(patsubst $(ARCH_DIR)/%.c,$(BUILD_DIR)/%.o,$(ARCH_SRCFILES)) $(patsubst $(ARCH_DIR)/%.S,$(BUILD_DIR)/%.o,$(ARCH_SRCFILES))
ARCH_DEPFILES := $(patsubst %.c,%.o,$(ARCH_SRCFILES)) $(patsubst %.S,%.o,$(ARCH_SRCFILES))

KERNEL_DIR := $(PROJ_ROOT)/kernel
KERNEL_SRCFILES := $(shell find $(KERNEL_DIR) -type f -name "*.c") $(shell find $(KERNEL_DIR) -type f -name "*.S")
KERNEL_OBJFILES := $(patsubst $(KERNEL_DIR)/%.c,$(BUILD_DIR)/%.o,$(KERNEL_SRCFILES)) $(patsubst $(KERNEL_DIR)/%.S,$(BUILD_DIR)/%.o,$(KERNEL_SRCFILES))
KERNEL_DEPFILES := $(patsubst %.c,%.o,$(KERNEL_SRCFILES)) $(patsubst %.S,%.o,$(KERNEL_SRCFILES))

ARCOS_SRCFILES := $(ARCH_SRCFILES) $(KERNEL_SRCFILES)
ARCOS_OBJFILES := $(ARCH_OBJFILES) $(KERNEL_OBJFILES)
ARCOS_DEPFILES := $(ARCH_DEPFILES) $(KERNEL_DEPFILES)

GLOBAL_ARFLAGS := rc
GLOBAL_CFLAGS  := $(WARNINGS) -I$(PROJ_ROOT)/include -MMD -g -std=gnu99
GLOBAL_LDFLAGS := 

OS := Arcos
ARCH ?= x86_64
TARGET_TYPE ?= elf

# TODO: Let the compiler(s) and binutils be changed by prefix/ARCH
CC := $(ARCH)-$(TARGET_TYPE)-gcc
AR := $(ARCH)-$(TARGET_TYPE)-ar
AS := $(ARCH)-$(TARGET_TYPE)-as
LD := $(ARCH)-$(TARGET_TYPE)-ld

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

arcos.iso: arcos.elf

arcos.elf: $(ARCOS_OBJFILES)
	@echo "Linking $(words $($^)) object files..."
	@$(LD) -T $(ARCH_DIR)/linker.ld -o $@ $<

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(GLOBAL_CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	@$(CC) $(GLOBAL_CFLAGS) -c $< -o $@
	
clean:
	@echo "Cleaning files..."
	-@$(RM) $(wildcard $(ARCOS_OBJFILES) $(ARCOS_DEPFILES) arcos.iso arcos) 

todolist: $(ARCOS_ALLFILES)
	-@for file in $(ARCOS_SRCFILES); do fgrep -H -e TODO -e FIXME $$file 2>/dev/null; done; true

.PHONY: clean
