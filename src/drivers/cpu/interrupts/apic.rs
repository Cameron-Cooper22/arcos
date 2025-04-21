use core::arch::x86_64::__cpuid;

use x86_64::registers::model_specific::Msr;

const IA32_APIC_BASE_MSR: u32 = 0x1b;
const APIC_ENABLE_BIT: u64 = 1 << 11;
const X2APIC_ENABLE_BIT: u64 = 1 << 10;
const IA32_X2APIC_SIVR: u32 = 0x80F;

pub enum ApicError {
    X2ApicNotSupported,
    ApicNotSupported,
    FailureToWriteMSR,
}

fn x2apic_supported() -> bool {
    let cpuid = unsafe { __cpuid(1) };
    let ecx_features = cpuid.ecx;
    let edx_features = cpuid.edx;
    ((ecx_features & (1 << 21)) != 0) && ((edx_features & (1 << 9)) != 0) // https://en.wikipedia.org/wiki/CPUID
}

fn apic_supported() -> bool {
    let cpuid = unsafe { __cpuid(1) };
    let edx_features = cpuid.edx;
    (edx_features & (1 << 9)) != 0
}

pub fn init() -> Result<(), ApicError> {
    if !apic_supported() {
        return Err(ApicError::ApicNotSupported);
    } else if !x2apic_supported() {
        return Err(ApicError::X2ApicNotSupported);
    }
    let mut apic_base_msr = Msr::new(IA32_APIC_BASE_MSR);
    let mut apic_base_val = unsafe { apic_base_msr.read() };
    apic_base_val |= APIC_ENABLE_BIT;
    apic_base_val |= X2APIC_ENABLE_BIT;
    unsafe {
        apic_base_msr.write(apic_base_val);
    }
    drop(apic_base_msr);
    drop(apic_base_val);

    let apic_base_msr = Msr::new(IA32_APIC_BASE_MSR);
    let apic_base_val = unsafe { apic_base_msr.read() };
    if (apic_base_val & (1 << 10) == 0) || (apic_base_val & (1 << 11) == 0) {
        return Err(ApicError::FailureToWriteMSR);
    }

    // past this point, APIC is enabled
    let mut sivr_msr = Msr::new(IA32_X2APIC_SIVR);
    let mut sivr_val = unsafe { sivr_msr.read() };
    sivr_val = (sivr_val & !0xff) | 0xff;
    sivr_val |= 1 << 8;
    unsafe {
        sivr_msr.write(sivr_val);
    }
    Ok(())
}
