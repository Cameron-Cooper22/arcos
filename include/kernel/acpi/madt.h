#ifndef __ARCOS_MADT
#define __ARCOS_MADT

#include <stddef.h>
#include <stdint.h>

#include <kernel/acpi/acpi.h>

#define MADT_LAPIC 0
#define MADT_IOAPIC 1
#define MADT_OVERRIDE 2

#define MADT_NMI 4
#define MADT_LAPIC_ADDR 5

struct madt_t {
  struct sdt_t sdt;
  uint32_t local_controller_addr;
  uint32_t flags;
  uint8_t madt_entries_begin[];
} __attribute__((packed));

struct madt_header_t {
  uint8_t type;
  uint8_t len;
} __attribute__((packed));

struct madt_lapic_t {
  struct madt_header_t header;
  uint8_t processor_id;
  uint8_t apic_id;
  uint32_t flags;
} __attribute__((packed));

struct madt_ioapic_t {
  struct madt_header_t header;
  uint8_t apic_id;
  uint8_t __zero;
  uint32_t phys_address;
  uint32_t gsi_base;
} __attribute__((packed));

struct madt_override_t {
  struct madt_header_t header;
  uint8_t bus_source;
  uint8_t irq_source;
  uint32_t gsi;
  uint16_t flags;
} __attribute__((packed));

struct madt_nmi_t { 
  struct madt_header_t header;
  uint8_t acpi_id;
  uint16_t flags;
  uint8_t lint_num;
} __attribute__((packed));

struct madt_lapic_addr_t {
  struct madt_header_t header;
  uint16_t __zero;
  uint64_t lapic_addr;
} __attribute__((packed));

extern bool madt_available;

extern struct madt_t *madt;

extern struct madt_local_apic_t **madt_local_apics;
extern size_t madt_local_apic_i;

extern struct madt_io_apic_t **madt_io_apics;
extern size_t madt_io_apic_i;

extern struct madt_iso_t **madt_isos;
extern size_t madt_iso_i;

extern struct madt_nmi_t **madt_nmis;
extern size_t madt_nmi_i;

void init_madt(void);

#endif
