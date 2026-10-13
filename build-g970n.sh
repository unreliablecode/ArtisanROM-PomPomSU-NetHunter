#!/bin/bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$ROOT"
export PATH="${LLVM_BIN:-/usr/lib/llvm-19/bin}:$PATH"
export ARCH=arm64 LOCALVERSION=
OUT=${OUT:-out-g970n}
JOBS=${JOBS:-$(getconf _NPROCESSORS_ONLN)}
case "$(clang --version | head -n 1)" in *'19.1.7'*) ;; *) echo 'Clang 19.1.7 is required.' >&2; exit 1;; esac
case "$(ld.lld --version)" in *'19.1.7'*) ;; *) echo 'LLD 19.1.7 is required.' >&2; exit 1;; esac
[ -f firmware/npu/NPU.bin ]
[ -f firmware/rtlwifi/rtl8188eufw.bin ]
make O="$OUT" LLVM=1 LLVM_IAS=1 HOSTCC=clang HOSTCXX=clang++ artisan_g970n_pompom_nethunter_defconfig
make O="$OUT" LLVM=1 LLVM_IAS=1 HOSTCC=clang HOSTCXX=clang++ -j"$JOBS"
ARTIFACTS="$OUT/artifacts"
mkdir -p "$ARTIFACTS/modules"
cp "$OUT/arch/arm64/boot/Image" "$ARTIFACTS/Image"
cp "$OUT/include/config/kernel.release" "$ARTIFACTS/kernel.release"
cp "$OUT/.config" "$ARTIFACTS/build.config"
for name in ch341 cp210x ftdi_sio pl2303 slcan gs_usb vcan r8188eu; do
    file=$(find "$OUT/drivers" -name "$name.ko" -print -quit)
    [ -n "$file" ] || { echo "Missing module: $name" >&2; exit 1; }
    cp "$file" "$ARTIFACTS/modules/$name.ko"
done
cp -a nethunter/g970n-nethunter-drivers "$ARTIFACTS/"
cp -a nethunter/r8188eu_beyond0lte "$ARTIFACTS/"
for name in ch341 cp210x ftdi_sio pl2303 slcan gs_usb vcan; do
    cp "$ARTIFACTS/modules/$name.ko" "$ARTIFACTS/g970n-nethunter-drivers/"
done
cp "$ARTIFACTS/modules/r8188eu.ko" "$ARTIFACTS/r8188eu_beyond0lte/"
echo "Build ready: $ARTIFACTS"
