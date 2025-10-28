#!/bin/sh

DEV_USB="/dev/sda"
boot_src="${DEV_USB}1"
rootfs_src="${DEV_USB}2"

DEV_EMMC="/dev/mmcblk1"
boot_dst="${DEV_EMMC}p1"
rootfs_dst="${DEV_EMMC}p2"

echo "boot_src: $boot_src, rootfs_src: $rootfs_src"
echo "boot_dst: $boot_dst, rootfs_dst: $rootfs_dst"

install_to_nand() {
  if [ -e $boot_src -a -e $rootfs_src ]; then

    cd /
    echo -n "Partitioning eMMC..."

    # Backup the bootloader, necessary for system recovery
    MYBOX_UBOOT="/tmp/mybox-bootloader.img"
    [[ -f "${MYBOX_UBOOT}" ]] && rm -f ${MYBOX_UBOOT}
    echo -n "Start backing up the default bootloader."
    dd if="${DEV_EMMC}" of="${MYBOX_UBOOT}" bs=1M count=4 conv=fsync
    dd if=/dev/zero of=${DEV_EMMC} bs=512 count=1 conv=fsync

    if grep -q ${boot_dst} /proc/mounts; then
      echo "Unmounting system partiton."
      umount -f ${boot_dst} || exit 1
    fi

    if grep -q ${rootfs_dst} /proc/mounts; then
      echo "Unmounting data partiton."
      umount -f ${rootfs_dst} || exit 1
    fi

    # Format emmc disk
    echo -n "Start create MBR and partittion."
    parted -s "${DEV_EMMC}" mklabel msdos
    parted -s "${DEV_EMMC}" mkpart primary 876MiB 2155MiB
    parted -s "${DEV_EMMC}" mkpart primary 2164MiB 100%

    echo -n "Write the mybox bootloader: [ ${MYBOX_UBOOT} ]"
    dd if="${MYBOX_UBOOT}" of="${DEV_EMMC}" conv=fsync bs=1 count=444
    dd if="${MYBOX_UBOOT}" of="${DEV_EMMC}" conv=fsync bs=512 skip=1 seek=1


    echo -n "Clear unused partitions..."
    dd if=/dev/zero of=/dev/boot bs=1M count=32 2>/dev/null
    dd if=/dev/zero of=/dev/recovery bs=1M count=32 2>/dev/null
    echo "done."

    if grep -q ${boot_dst} /proc/mounts; then
      echo "Unmounting system partiton."
      umount -f ${boot_dst} || exit 1
    fi

    echo -n "Copying system partition..."
    dd if=${boot_src} of=${boot_dst} bs=512 conv=notrunc
    echo "done."

    echo -n "Changing system files..."
    mkdir -p /tmp/system
    mount -t vfat ${boot_dst} /tmp/system
    sed -i "s|${rootfs_src}|${rootfs_dst}|g" /tmp/system/extlinux/extlinux.conf && sync
    umount /tmp/system
    echo "done."

    if grep -q ${rootfs_dst} /proc/mounts; then
      echo "Unmounting data partiton."
      umount -f ${rootfs_dst} || exit 1
    fi

    echo -n "Copying data partition..."
    dd if=${rootfs_src} of=${rootfs_dst} bs=512 conv=notrunc
    echo "done."

    echo "All done!"
    echo "Please unplug the USB drive and reboot!"
  else
    echo "No SRC data found on USB! Exiting..."
  fi
}

echo "This script will erase BOOT, RECOVERY, SYSTEM and DATA on your device"
echo "and install OpenWRT that you booted from SD card/USB drive."
echo ""
echo "The script does not have any safeguards!"
echo ""

read -p "Type \"yes\" if you know what you are doing or anything else to exit: " choice
case "$choice" in
yes) install_to_nand ;;
*) exit 0 ;;
esac