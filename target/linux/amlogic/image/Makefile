# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2012-2019 OpenWrt.org
# Copyright (C) 2016-2017 LEDE project

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += UBOOT_DEVICE_NAME

FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_KERNEL_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

define Build/Compile
	$(CP) $(LINUX_DIR)/COPYING $(KDIR)/COPYING.linux
endef

### Image scripts ###
define Build/boot-common
	rm -f $@.boot
	mkfs.fat -n boot -C $@.boot $(FAT32_BLOCKS)
	mcopy -i $@.boot $(KDIR)/image-$(firstword $(DEVICE_DTS)).dtb ::amlogic.dtb
	mcopy -i $@.boot $(IMAGE_KERNEL) ::kernel.img
	mcopy -i $@.boot "$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-u-boot.bin ::u-boot.ext
endef

define Build/boot-script
	# Make an U-boot image and copy it to the boot partition
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d aml_autoscript.cmd $@-aml_autoscript
	mcopy -i $@.boot $@-aml_autoscript ::aml_autoscript
	mcopy -s -i $@.boot extlinux ::
endef

define Build/sdcard-img
	SIGNATURE="$(IMG_PART_SIGNATURE)" \
	./gen_aml_sdcard_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
endef

### Devices ###

include $(SUBTARGET).mk

$(eval $(call BuildImage))
