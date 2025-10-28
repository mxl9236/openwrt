include $(TOPDIR)/rules.mk

PKG_VERSION:=2025.07
PKG_RELEASE:=1

PKG_HASH:=0f933f6c5a426895bf306e93e6ac53c60870e4b54cda56d95211bec99e63bec7
PKG_MAINTAINER:=mxl9236 <mxl9236@gmail.com>

UBOOT_USE_INTREE_DTC:=1

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=amlogic
  UENV:=default
  HIDDEN:=1
endef

define U-Boot/phicomm-n1
  BUILD_SUBTARGET:=mesongx
  UBOOT_CONFIG:=phicomm-n1
  NAME:=Phicomm N1
  BUILD_DEVICES:= \
  phicomm_n1
endef

UBOOT_TARGETS := phicomm-n1

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(PKG_BUILD_DIR)/configs/libretech-cc_defconfig $(PKG_BUILD_DIR)/configs/phicomm-n1_defconfig
	$(SED) 's/meson-gxl-s905x-libretech-cc/meson-gxl-s905d-phicomm-n1/g' $(PKG_BUILD_DIR)/configs/phicomm-n1_defconfig
	$(SED) 's/libretech-cc/phicomm-n1/g' $(PKG_BUILD_DIR)/configs/phicomm-n1_defconfig
	printf "CONFIG_LZ4=y\nCONFIG_LZO=y\nCONFIG_LZMA=y\nCONFIG_BOOTDELAY=0\nCONFIG_EFI_LOADER=n\n" >> $(PKG_BUILD_DIR)/configs/phicomm-n1_defconfig
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/u-boot.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot.bin
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))