#!/system/bin/sh
MODDIR=${0%/*}
EXPECTED_KERNEL='4.14.356-openela-rc1-ArtisanKRNL-v3.1.5-PomPomSU-NH-r3'
[ "$(uname -r)" = "$EXPECTED_KERNEL" ] || exit 0
for module in ch341 cp210x ftdi_sio pl2303 slcan gs_usb vcan; do
    grep -q "^$module " /proc/modules && continue
    if insmod "$MODDIR/$module.ko"; then
        log -t G970N-NetHunter "Loaded $module"
    else
        log -p e -t G970N-NetHunter "Failed to load $module"
    fi
done
