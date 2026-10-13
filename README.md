# ArtisanROM + PomPomSU + NetHunter

Kernel source for the Korean Galaxy S10e (SM-G970N) running ArtisanROM.

Based on [Artisan's Exynos 9820 kernel](https://github.com/Android-Artisan/android_kernel_samsung_exynos9820), commit `9a0a792d227c`, with Linux 4.14.356 and PomPomSU 3.4.1. The root driver uses manual hooks, version 33333 and UAPI 5. Its trusted manager package is `com.pomni.unreliablecode`.

## Support

- USB HID, ACM, generic serial, RNDIS and mass storage.
- CH341, CP210X, FTDI and PL2303 serial adapters.
- SocketCAN through `gs_usb`, `slcan` and `vcan`.
- RTL8188EU with embedded firmware, alongside Artisan's existing wireless drivers.
- TUN, packet sockets and the Kali NetHunter chroot.

The PomPomSU changes fix package scanning under filesystem locks, seccomp declarations and the SELinux status hook's 4.14 page-pointer handling. The customized kernel code is included under `KernelSU-Next`; it does not need a submodule checkout.

## Build

Use Linux with Clang and LLD 19.1.7, Make, Python 3, Bison, Flex, bc, OpenSSL development headers and libelf development headers.

```sh
git clone https://github.com/unreliablecode/ArtisanROM-PomPomSU-NetHunter.git
cd ArtisanROM-PomPomSU-NetHunter
export LLVM_BIN=/usr/lib/llvm-19/bin
./build-g970n.sh
```

The image, matching modules and driver packages are written to `out-g970n/artifacts`. `JOBS` and `OUT` can override the parallel job count and output directory.

## Installation

Repack `Image` with the ramdisk and boot header from the installed G970N ROM. Keep a backup of BOOT and use modules from the same build. This repository does not flash partitions or replace recovery.

The generated driver directories are data-only KernelSU modules. Their startup scripts check the running kernel release before loading anything.

## Device tests

On ArtisanROM Android 16, r3 booted with root, passed SELinux status read/mmap checks under an app UID with seccomp enabled, and loaded all eight drivers after reboot. Kali reported the expected kernel release.

Wired USB remains intermittent. The fault also occurred with the original kernel and with optional drivers disabled. External Wi-Fi injection and Apple-device discovery have not been verified.

## Credits and licensing

Artisan supplies the Samsung kernel base. PomPomSU derives from KernelSU-Next. Existing notices are retained in `COPYING` and the KernelSU license files. Realtek firmware is distributed under `firmware/rtlwifi/LICENCE.rtlwifi_firmware.txt`.
