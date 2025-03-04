CC := x86_64-elf-gcc
SRC_FILES := $(wildcard kernel/*/*.[S])
OBJ_FILES := $(patsubst %, %.o, $(basename $(SRC_FILES)))

CFLAGS := -Wall -Wextra -pedantic -ffreestanding -nostdinc 
CFLAGS += -ggdb -O0
ASFLAGS += -ggdb
CPPFLAGS += -Iinclude -Ilibc/include
LDFLAGS := -n -nostdlib -Tlinker.ld

kernel.iso: $(OBJ_FILES)
	$(LINK.c) $^ -o $@

DEP := $(OBJ_FILES:.o=.d)
DEPFLAGS = -MT $@ -MMD -MP -MF $*.d
$(OBJ_FILES): CPPFLAGS += $(DEPFLAGS)
%.d: ;

DESTDIR ?= $(BUILDROOT)sysroot

$(DESTDIR)$(PREFIX)/kernel.iso: kernel.iso
	install -D kernel.iso $(DESTDIR)$(PREFIX)/kernel.iso

build: $(DESTDIR)$(PREFIX)/kernel.iso

clean:
	rm -rf $(OBJ) $(DEP) kernel

.PHONY: build

include $(DEP)
