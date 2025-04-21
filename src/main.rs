#![no_main]
#![no_std]
#![feature(custom_test_frameworks)]
#![test_runner(arcos::test_runner)]
#![feature(abi_x86_interrupt)]

use core::panic::PanicInfo;

use arcos::{init, println, serial_println};

#[cfg(not(test))]
#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    use arcos::hlt_loop;

    init();
    println!("Hello, world!");

    hlt_loop()
}

#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    use arcos::hlt_loop;

    println!("{}", info);
    hlt_loop()
}

#[test_case]
fn trivial_assertion() {
    serial_println!("trivial assertion... ");
    assert_eq!(1, 1);
    serial_println!("[ok]");
}
