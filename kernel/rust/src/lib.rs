#![no_std]
#![feature(custom_test_frameworks)]

use core::panic::PanicInfo;

pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
