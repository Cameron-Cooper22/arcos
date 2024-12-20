#ifndef ARCOS_HAL_DEFS_H
#define ARCOS_HAL_DEFS_H

/* ============================================
 * || ID || BASE ADDRESS || INSTANCE || DESC ||
 * ============================================
 */


#define APPROTECT_INST 	0x40000000
#define CLOCK_INST	0x40000000
#define POWER_INST	0x40000000
// #define GPIO_INST	0x50000000 /* deprecated */
#define P0_INST		0x50000000
#define P1_INST		0x50000300
#define RADIO_INST	0x40001000
// #define UART0_INST	0x40002000 /* deprecated */
#define UARTE0_INST	0x40002000

#define SPIO_INST	0x40003000
#define SPIM0_INST	0x40003000
#define SPIS0_INST	0x40003000
#define TWI0_INST	0x40003000
#define TWIM0_INST	0x40003000
#define TWIS0_INST	0x40003000

#define SPI1_INST	0x40004000
#define SPIM1_INST	0x40004000
#define SPIS1_INST	0x40004000
#define TWI1_INST	0x40004000
#define TWIM1_INST	0x40004000
#define TWIS1_INST	0x40004000

#define NFCT_INST	0x40005000
#define GPIOTE_INST	0x40006000
#define SAADC_INST	0x40007000

#define TIMER0_INST	0x40008000
#define TIMER1_INST	0x40009000
#define TIMER2_INST	0x4000a000

#define RTC0_INST	0x4000b000
#define TEMP_INST	0x4000c000
#define RNG_INST	0x4000d000
#define ECB_INST	0x4000e000
#define AAR_INST	0x4000f000
#define CCM_INST	0x4000f000
#define WDT_INST	0x40010000
#define RTC_INST	0x40011000
#define QDEC_INST	0x40012000
#define COMP_INST	0x40013000
#define LPCOMP_INST	0x40013000

#define EGU0_INST	0x40014000
#define SWI0_INST	0x40014000
#define EGU1_INST	0x40015000
#define SWI1_INST	0x40015000
#define EGU2_INST	0x40016000
#define SWI2_INST	0x40016000
#define EGU3_INST	0x40017000
#define SWI3_INST	0x40017000
#define EGU4_INST	0x40018000
#define SWI4_INST	0x40018000
#define EGU5_INST	0x40019000
#define SWI5_INST	0x40019000

#define TIMER3_INST	0x4001a000
#define TIMER4_INST	0x4001b000

#define PWM0_INST	0x4001c000
#define PDM_INST	0x4001d000
#define ACL_INST	0x4001e000
#define NVMC_INST	0x4001e000
#define PPI_INST	0x4001f000
#define MWU_INST	0x40020000

#define PWM1_INST	0x40021000
#define PWM2_INST	0x40022000

#define SPIM2_INST	0x40023000
#define SPIS2_INST	0x40023000
#define RTC2_INST	0x40024000
#define I2S_INST	0x40025000
#define FPU_INST	0x40026000
#define USBD_INST	0x40027000
#define UARTE1_INST	0x40028000
// external memory interface
#define QSPI_INST	0x40029000

#define CRYPTOCELL_INST 	0x5002a000
#define CC_AES_INST		0x5002b000
#define	CC_CTL_INST		0x5002b000
#define CC_DIN_INST		0x5002b000
#define CC_DOUT_INST		0x5002b000
#define CC_HASH_INST		0x5002b000
#define CC_HOST_RGF_INST	0x5002b000
#define CC_MISC_INST		0x5002b000
#define CC_PKA_INST		0x5002b000
#define CC_RNG_INST		0x5002b000
#define CC_RNG_INST		0x5002b000
#define CC_RNG_SRAM_INST	0x5002b000

#define PWM3_INST	0x4002d000
#define SPIM3_INST	0x4002f000





#endif
