###############################################
################## BASE VARS ##################
###############################################

# TODO: Let the compiler(s) and binutils be changed by prefix/ARCH
CC := x86_64-elf-gcc
LD := x86_64-elf-ld

# specified 'KERNEL' because some directories should ignore some errors
CWARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
	     -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
	     -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
	     -Wconversion -Wstrict-prototypes

# used for creating archives WITHOUT linking.
AR := x86_64-elf-ar
OBJCOPY := x86_64-elf-objcopy

PROJ_ROOT := $(shell pwd)
BUILD_DIR := $(PROJ_ROOT)/build

SUPPORTED_ARCHS := x86_64
SUBDIRS :=

GLOBAL_ARFLAGS := rc
GLOBAL_CFLAGS := -I$(PROJ_ROOT)/include/ -MMD -g -std=gnu99

ARCH_DIR := $(PROJ_ROOT)/arch/$(ARCH)
ARCH_SRCFILES := $(shell find $(ARCH_DIR) -type f -name "*.c") $(shell find $(ARCH_DIR) -type f -name "*.S")
ARCH_OBJFILES := $(patsubst $(ARCH_DIR)/%.c,$(BUILD_DIR)/$(ARCH_DIR)/%.o,$(ARCH_SRCFILES)) $(patsubst $(ARCH_DIR)/%.S,$(BUILD_DIR)/$(ARCH_DIR)/%.o,$(ARCH_SRCFILES))
ARCH_DEPFILES := $(patsubst %.c,%.o,$(ARCH_SRCFILES)) $(patsubst %.S,%.o,$(ARCH_SRCFILES))
ARCH_CFLAGS := $(GLOBAL_CFLAGS) $(CWARNINGS)

KERNEL_DIR := $(PROJ_ROOT)/kernel
KERNEL_SRCFILES := $(shell find $(KERNEL_DIR) -type f -name "*.c") $(shell find $(KERNEL_DIR) -type f -name "*.S")
KERNEL_OBJFILES := $(patsubst $(KERNEL_DIR)/%.c,$(BUILD_DIR)/$(KERNEL_DIR)/%.o,$(KERNEL_SRCFILES)) $(patsubst $(KERNEL_DIR)/%.S,$(BUILD_DIR)/$(KERNEL_DIR)%.o,$(KERNEL_SRCFILES))
KERNEL_DEPFILES := $(patsubst %.c,%.o,$(KERNEL_SRCFILES)) $(patsubst %.S,%.o,$(KERNEL_SRCFILES))
KERNEL_CFLAGS := $(GLOBAL_CFLAGS) $(CWARNINGS)

OS := Arcos
ARCH ?=

ifeq ($(ARCH),)
	$(error ARCH is not defined. Please define an arch to target.)
endif
ifeq ($(filter $(ARCH),$(SUPPORTED_ARCHS)),)
	$(error Unsupported ARCH "$(ARCH)". Supported: $(SUPPORTED_ARCHS))
endif


###############################################
################## RECIPES ####################
###############################################
all:
	@echo "Building for architecture: $(ARCH)"
	@mkdir -p $(BUILD_DIR)

clean:
	# should keep the directory structure
	-@$(RM) $(wildcard $(KERNEL_OBJFILES) $(KERNEL_DEPFILES) arcos.iso arcos) 

.PHONY: clean $(SUPPORTED_ARCHS)

$(SUPPORTED_ARCHS):
	@echo "Building for $@"
