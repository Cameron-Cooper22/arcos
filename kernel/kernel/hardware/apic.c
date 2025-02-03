#include "kernel/acpi/madt.h"
#include <kernel/apic.h>
#include <stddef.h>

struct lapic_info lapic_list[MAX_LAPICS];
struct madt_ioapic_t* ioapic_list[MAX_IOAPICS];
struct madt_override_t* override_list[MAX_OVERRIDES];
struct madt_nmi_t *nmi_list[MAX_NMI];
size_t lapic_list_size;
size_t ioapic_list_size;
size_t override_list_size;
size_t nmi_list_size;


/* Possible error handling type, similar to Result<> in Rust?
 * struct Result {
 * 	void* Ok
 * 	size_t Ok_size
 * 	void* Error;
 * 	size_t Error_size;
 * }
 */

// TODO: Find some way to effectively handle errors
static void add_lapic(struct madt_lapic_t* entry) {
  if (lapic_list_size >= MAX_LAPICS) return;
  lapic_list[lapic_list_size].present = (entry -> flags != 0);
  lapic_list[lapic_list_size].id = entry -> apic_id;
  lapic_list[lapic_list_size].acpi_id = entry -> processor_id;
  lapic_list_size++;
  // TODO: log added lapic data
}

static void add_ioapic(struct madt_ioapic_t* entry) {
  if (ioapic_list_size >= MAX_IOAPICS) return;

  
}
