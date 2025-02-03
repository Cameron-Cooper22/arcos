#ifndef __ARCOS_APIC
#define __ARCOS_APIC

#include "kernel/acpi/madt.h"
#include "kernel/memory.h"
#include <kernel/interrupts.h>
#include <stddef.h>
#include <stdint.h>
#include <limits.h>

#define MAX_LAPICS MAX_CORES
#define MAX_IOAPICS 16
#define MAX_NMI (2 * MAX_LAPICS)
#define MAX_OVERRIDES 48

#define IPI_INIT	0x4500
#define IPI_START_UP	0x4600
#define IPI_FIXED	0x4000

#define IPI_BRAODCAST (0b11 << 18)

struct lapic_info {
  uint8_t id;
  uint8_t acpi_id;
  uint8_t present;
  uint32_t ticks_per_10ms;
};

void apic_init(void);

void lapic_enable(void);
void lapic_eoi(uint8_t);
uint8_t lapic_id(void);
void lapic_send_ipi(uint8_t target, uint32_t flags);
uint32_t lapic_timer_prepare(void);
void lapic_timer_enable(void);

void ioapic_init(void);
void ioapic_redirect(uint32_t gsi, uint8_t source, uint16_t flags, uint8_t target_apic);
void ioapic_mask(uint32_t gsi);
void ioapic_unmask(uint32_t gsi);
uint8_t ioapic_isa_to_gsi(uint8_t isa);
uint8_t ioapic_gsi_to_isa(uint8_t gsi);

extern struct lapic_info lapic_list[MAX_LAPICS];
extern struct madt_ioapic_t* ioapic_list[MAX_IOAPICS];
extern struct madt_override_t* override[MAX_OVERRIDES];
extern struct madt_nmi_t* nmi_list[MAX_NMI];
extern size_t lapic_list_size;
extern size_t ioapic_list_size;
extern size_t override_list_size;
extern size_t nmi_list_size;
extern virtaddr_t lapic_base;

#endif
