#!/bin/sh

set -eu

SDK_DIR="${SDK_DIR:-/root/openwrt-sdk-24.10.0-mediatek-filogic_gcc-13.3.0_musl.Linux-x86_64}"

cd "$SDK_DIR"

[ -d package/amneziawg-openwrt ] || git clone https://github.com/amnezia-vpn/amneziawg-openwrt.git package/amneziawg-openwrt

sed -i \
  -e 's/PKG_VERSION:=1.0.20240213/PKG_VERSION:=1.0.20260618-2/' \
  -e 's/PKG_HASH:=.*/PKG_HASH:=skip/' \
  package/amneziawg-openwrt/amneziawg-tools/Makefile

cd /root
rm -rf amneziawg-linux-kernel-module
git clone --depth 1 --branch v1.0.20260611 https://github.com/amnezia-vpn/amneziawg-linux-kernel-module.git

cd "$SDK_DIR"

cat > package/amneziawg-openwrt/kmod-amneziawg/Makefile <<'EOF'
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=kmod-amneziawg
PKG_VERSION:=1.0.20260611
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/amneziawg
  SECTION:=kernel
  CATEGORY:=Kernel Modules
  SUBMENU:=Network Support
  URL:=https://amnezia.org/
  TITLE:=AmneziaWG Kernel Module
  FILES:=$(PKG_BUILD_DIR)/amneziawg.ko
  DEPENDS:=+kmod-udptunnel4 +kmod-udptunnel6 +kmod-crypto-lib-chacha20poly1305 +kmod-crypto-lib-curve25519
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) /root/amneziawg-linux-kernel-module/src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)" \
		EXTRA_CFLAGS="$(BUILDFLAGS)" \
		modules
endef

$(eval $(call KernelPackage,amneziawg))
EOF

./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make package/amneziawg-tools/compile V=s
make package/luci-proto-amneziawg/compile V=s
make package/kmod-amneziawg/compile V=s

find bin -name '*amnezia*.ipk' -o -name '*awg*.ipk'
