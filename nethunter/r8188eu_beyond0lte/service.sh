#!/system/bin/sh

MODDIR=${0%/*}
EXPECTED_KERNEL='4.14.356-openela-rc1-ArtisanKRNL-v3.1.5-PomPomSU-NH-r3'
CURRENT_KERNEL=$(uname -r)

if [ "$CURRENT_KERNEL" != "$EXPECTED_KERNEL" ]; then
    log -t R8188EU "Not loading: expected $EXPECTED_KERNEL, found $CURRENT_KERNEL"
    exit 0
fi

log -t R8188EU 'RTL8188EU firmware is embedded in this kernel'

if grep -q '^r8188eu ' /proc/modules 2>/dev/null; then
    log -t R8188EU "RTL8188EU driver is already loaded"
    exit 0
fi

adapter_present() {
    for vendor_file in /sys/bus/usb/devices/*/idVendor; do
        [ -f "$vendor_file" ] || continue
        [ "$(cat "$vendor_file" 2>/dev/null)" = "2357" ] || continue
        device_dir=${vendor_file%/idVendor}
        [ -f "$device_dir/idProduct" ] || continue
        [ "$(cat "$device_dir/idProduct" 2>/dev/null)" = "010c" ] && return 0
    done
    return 1
}

i=0
while [ "$i" -lt 30 ]; do
    adapter_present && break
    sleep 1
    i=$((i + 1))
done

if /system/bin/insmod "$MODDIR/r8188eu.ko"; then
    log -t R8188EU "RTL8188EU driver loaded"
else
    log -p e -t R8188EU "Could not load RTL8188EU driver"
fi
