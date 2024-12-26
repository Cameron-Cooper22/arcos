#![no_std]
#![no_main]
#![feature(custom_test_frameworks)]
#![test_runner(crate::test_runner)]
#![reexport_test_harness_main = "test_main"]
use core::panic::PanicInfo;

mod vga;

static HELLO_WORLD: &[u8] = b"Hello, World!";

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}
/* vga buff is 25x80 */
#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("RAHHH THIS IS MY TIME TO SHINE BITCH");

    #[cfg(test)]
    test_main();

    loop {}
}

#[cfg(test)]
pub fn test_runner(tests: &[&dyn Fn()]) {
    println!("Running {} tests", tests.len());
    for test in tests {
        test();
    }
}

#[test_case]
fn assertion() {
    print!("trivial assertion... ");
    assert_eq!(1, 1);
    println!("[ok]")
}
