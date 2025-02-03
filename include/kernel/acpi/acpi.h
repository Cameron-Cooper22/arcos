#ifndef __ARCOS_ACPI
#define __ARCOS_ACPI

#include "kernel/memory.h"
#include <stdint.h>
#define ACPI_TABLES_MAX 256

struct rsdp_t {
  char signature[8];
  uint8_t checksum;
  char oem_id[6];
  uint8_t rev;
  uint32_t rsdt_addr;
  uint32_t length;
  uint64_t xsdt_addr;
  uint8_t ext_checksum;
  uint8_t reserved[3];
} __attribute__((packed));

struct sdt_t {
  char signature[4];
  uint32_t length;
  uint8_t rev;
  uint8_t checksum;
  char oem_id[6];
  char oem_table_id[8];
  uint32_t oem_rev;
  uint8_t creator_id[4];
  uint32_t creator_rev;
} __attribute__((packed));

struct rsdt_t {
  struct sdt_t sdt;
  uint32_t sdt_ptr[];
} __attribute__((packed));

struct xsdt_t {
  struct sdt_t sdt;
  uint64_t sdt_ptr[];
} __attribute__((packed));

extern struct rsdp_t* rsdp;
extern struct rsdp_t* rsdt;
extern struct xsdt_t* xsdt;

void init_acpi(void);
virtaddr_t acpi_find_table(char* signature);

#endif
