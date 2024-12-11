#![no_std]
#![no_main]

use defmt::*;
use embassy_executor::Spawner;
use embedded_storage_async::nor_flash::*;
use futures::pin_mut;
use nrf_softdevice::{Flash, Softdevice};

mod ble;
mod hid;
mod keeb;

mod boot {
    use core::arc
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    defmt::error!("panicked");
    exit()
}


pub fn exit() -> ! {
    loop {
        cortex_m::asm::bkpt();
    }
}

#[embassy_executor::task]
async fn softdevice_task(sd: &'static Softdevice) -> ! {
    sd.run().await
}


fn main() {
    println!("Hello, world!");
    exit();
}
