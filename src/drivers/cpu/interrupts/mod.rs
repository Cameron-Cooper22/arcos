use i8259pic::InterruptIndex;
use lazy_static::lazy_static;
use x86_64::structures::idt::{InterruptDescriptorTable, InterruptStackFrame};

pub mod apic;
pub mod i8259pic;

use crate::gdt;
use crate::println;

lazy_static! {
    static ref IDT: InterruptDescriptorTable = {
        let mut idt = InterruptDescriptorTable::new();
        idt.breakpoint.set_handler_fn(breakpoint_handler);
        unsafe {
            idt.double_fault
                .set_handler_fn(double_fault_handler)
                .set_stack_index(gdt::DOUBLE_FAULT_IST_IDX);
        }
        idt
    };
}

pub fn init_idt() {
    IDT.load();
}

// The initialization of the interrupt controller should be
// 1. init the 8259pic, fairly safe to assume it will be supported
// 2. check for APIC, if it exists switch over to it
// 3. check for X2APIC, if it exists switch over to it
pub fn init_interrupt_controller() {
    i8259pic::init();
}

extern "x86-interrupt" fn breakpoint_handler(stack_frame: InterruptStackFrame) {
    println!("EXCEPTION: BREAKPOINT\n{:#?}", stack_frame);
}

extern "x86-interrupt" fn double_fault_handler(
    stack_frame: InterruptStackFrame,
    _error_code: u64,
) -> ! {
    panic!("EXCEPTION: DOUBLE_FAULT\n{:#?}", stack_frame);
}

extern "x86-interrupt" fn page_fault_handler(stack_frame: InterruptStackFrame) {
    println!("EXCEPTION: PAGE_FAULT\n{:#?}", stack_frame);
}

extern "x86-interrupt" fn timer_interrupt_handler(_stack_frame: InterruptStackFrame) {
    println!(".");
    // TODO: this to a #[cfg()] directive to support this and APIC
    unsafe {
        i8259pic::PICS
            .lock()
            .notify_end_of_interrupt(InterruptIndex::Timer as u8);
    }
}
