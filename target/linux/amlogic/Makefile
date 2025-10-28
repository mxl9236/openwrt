# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2006-2013 OpenWrt.org

include $(TOPDIR)/rules.mk

BOARD:=amlogic
BOARDNAME:=Amlogic Meson family
FEATURES:=audio boot-part display ext4 fpu gpio rootfs-part squashfs usb usbgadget
SUBTARGETS:=mesongx

KERNEL_PATCHVER:=6.6

define Target/Description
	Build firmware image for Amlogic Meson SoC devices.
	Currently produces SD Card/USB disk image.
endef

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += e2fsprogs mkf2fs parted partx-utils

KERNELNAME:=Image dtbs

$(eval $(call BuildTarget))
