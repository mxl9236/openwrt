# SPDX-License-Identifier: GPL-2.0-only

define Device/Default
  PROFILES := Default
  KERNEL_LOADADDR := 0x01d80000
  KERNEL_ENTRY_POINT := 0x01d80000
  KERNEL := kernel-bin | lzma | uImage lzma
  IMAGES := sysupgrade.img.gz
  DEVICE_DTS_DIR := $(DTS_DIR)/amlogic
  DEVICE_DTS = $$(SOC)-$(subst _,-,$(1))
endef

define Device/phicomm_n1
  DEVICE_VENDOR := Phicomm
  DEVICE_MODEL := N1
  SOC := meson-gxl-s905d
  UBOOT_DEVICE_NAME := phicomm-n1
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | sdcard-img | gzip | append-metadata
  DEVICE_PACKAGES := kmod-brcmfmac brcmfmac-firmware-43455-sdio-phicomm-n1 wpad-basic-mbedtls
endef
TARGET_DEVICES += phicomm_n1
