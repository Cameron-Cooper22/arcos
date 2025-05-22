###############################################
################## BASE VARS ##################
###############################################

CC := x86_64-elf-gcc
LD := x86_64-elf-ld

# specified 'KERNEL' because some directories should ignore some errors
KERNEL_CWARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
	     -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
	     -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
	     -Wconversion -Wstrict-prototypes

# used for creating archives WITHOUT linking.
AR := x86_64-elf-ar
OBJCOPY := x86_64-elf-objcopy
GLOBAL_CFLAGS := -I./include/ -MMD -g -std=gnu99
KERNEL_CFLAGS := $(GLOBAL_CFLAGS) $(CWARNINGS)
# replace and create. supress warnings
GLOBAL_ARFLAGS := rc
LDFLAGS :=

SUPPORTED_ARCHS := x86_64

SUBDIRS :=


# these are always built so who gives a fuck
KERNEL_DIR := ./kernel
KERNEL_SRCFILES := $(shell find $(KERNEL_DIR) -type f -name "*.c")
KERNEL_OBJFILES := $(patsubst %.c,%.o,$(KERNEL_SRCFILES))
KERNEL_DEPFILES := $(patsubst %.c,%.d,$(KERNEL_SRCFILES))

BUILD_DIR := ./build

OS := Arcos

###############################################
################## RECIPES ####################
###############################################
all:
	ifndef ARCOS_ARCH
		$(error ARCOS_ARCH is not defined. Set it in your environment, currently supported archs are: $(SUPPORTED_ARCHS))
	endif


clean:
	# should keep the directory structure
	-@$(RM) $(wildcard $(KERNEL_OBJFILES) $(KERNEL_DEPFILES) arcos.iso arcos) 

.PHONY: clean
