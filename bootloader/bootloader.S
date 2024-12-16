#define __STARTUP_CONFIG_STACK_SIZE 0x1000
/* aligned to 8 bytes, 2^3 */
#define __STARTUP_CONFIG_STACK_ALIGNMENT 3

#define __STARTUP_HEAP_SIZE 0x1000

  .syntax unified
  .arch armv7e-m

  /* Defining the stack */
  .section .stack
  .align __STARTUP_CONFIG_STACK_ALIGNMENT
  .equ Stack_Size, __STARTUP_CONFIG_STACK_SIZE
  .globl __StackTop
  .globl __StackLimit
__StackLimit:
  .space Stack_Size
  .size __StackLimit, . - __StackLimit
__StackTop:
  .size __StackTop, . - __StackTop
  
  /* defining heap, dont think I will use it
   * much for the keyboard but it can be 
   * useful
   */
  .section .heap
  .align 3
  .equ Heap_Size, __STARTUP_HEAP_SIZE
  .globl __HeapBase
  .globl __HeapLimit
__HeadBase:
  .if Heap_Size
  .space Heap_Size
  .endif
  .size __HeapBase, . - __HeapBase
__HeapLimit:
  .size __HeapLimit, . - __HeapLimit

  .section .isr_vector, "ax"
  .align 2
  .globl __isr_vector
  /* INTERRUPT VECTORS, define them in C */
__isr_vector:
  .long	__StackTop
  .long Reset_Handler
  .long NMI_Handler
  .long HardFault_Handler
  .long MemoryManagement_Handler
  .long BusFault_Handler
  .long UsageFault_Handler
  .long 0
  .long 0
  .long 0
  .long 0
  .long SVC_Handler
  .long DebugMon_Handler
  .long 0
  .long PendSV_Handler
  .long SysTick_Handler

  /* peripheral interrupts */
  .long POWER_CLOCK_IRQHandler
  .long RADIO_IRQHandler
  .long UARTE0_UART0_IRQHandler
  .long SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler
  .long SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler
  .long NFCT_IRQHandler
  .long GPIOTE_IRQHandler
  .long SAADC_IRQHandler
  .long TIMER0_IRQHandler
  .long TIMER1_IRQHandler
  .long RTC0_IRQHandler
  .long TEMP_IRQHandler
  .long RNG_IRQHandler
  .long ECB_IRQHandler
  .long CCM_AAR_IRQHandler
  .long WDT_IRQHandler
  .long RTC1_IRQHandler
  .long QDEC_IRQHandler
  .long COMP_LPCOMP_IRQHandler
  .long SWI0_EGU0_IRQHandler
  .long SWI1_EGU1_IRQHandler
  .long SWI2_EGU2_IRQHandler
  .long SWI3_EGU3_IRQHandler
  .long SWI4_EGU4_IRQHandler
  .long SWI5_EGU5_IRQHandler
  .long TIMER3_IRQHandler
  .long TIMER4_IRQHandler
  .long PWM0_IRQHandler
  .long PDM_IRQHandler
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long MWU_IRQHandler
  .long PWM1_IRQHandler
  .long PWM2_IRQHandler
  .long SPIM2_SPIS2_SPI2_IRQHandler
  .long RTC2_IRQHandler
  .long I2S_IRQHandler
  .long FPU_IRQHandler
  .long USBD_IRQHandler
  .long UARTE1_IRQHandler
  .long QSPI_IRQHandler
  .long CRYPTOCELL_IRQHandler
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long PWM3_IRQHandler
  .long 0                           /*Reserved */
  .long SPIM3_IRQHandler
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */
  .long 0                           /*Reserved */

  .size __isr_vector, . - __isr_vector

/* Reset Handler */
  .text
  .thumb
  .thumb_func
  .align 1
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:

  /* Loop that copies data from ROM to RAM
   * The ranges of memcpy are specified by
   * 	__etext: LMA of start of section to copy from, usually end of text
   *	__data_start__: VMA of start of section to copy to
   *	__bss_start__: VMA of end of section to copy to. normally
   *	               __data_end__ is used, but using __bss_start__,
   *		       the user can add a data section before BSS with the
   *		       INSERT AFTER command
   */
#ifndef __STARTUP_SKIP_ETEXT
  ldr r1, =__etext
  ldr r2, =__data_start__
  ldr r3, =__bss_start__

  subs r3, r3, r2
  ble .L_loop1_done

.L_loop1:
  subs r3, r3, #4
  ldr r0, [r1,r3]
  str r0, [r2,r3]
  bgt .L_loop1

.L_loop1_done:
#endif
  /* Normall
