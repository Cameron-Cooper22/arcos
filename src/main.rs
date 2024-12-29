#![no_std]
#![no_main]
#![feature(custom_test_frameworks)]
#![test_runner(arcos::test_runner)]
#![reexport_test_harness_main = "test_main"]

use core::panic::PanicInfo;
use arcos::println;

static _HELLO_WORLD: &[u8] = b"Hello, World!";

#[allow(clippy::cfg_not_test)]
#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}

#[cfg(test)]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    arcos::test_panic_handler(info);
}

/* vga buff is 25x80 */
#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("RAHHH THIS IS MY TIME TO SHINE BITCH");

    arcos::init();


    #[cfg(test)]
    test_main();

    println!("It crashed, how the hell can you even see this message");

    loop {}
}


