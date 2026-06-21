# Packages

Здесь лежат готовые `.ipk` пакеты для проверенной конфигурации роутера.

## Совместимость

Папка:

```text
openwrt-24.10.0-mediatek-filogic-kernel-6.6.73
```

подходит для:

```text
OpenWrt: 24.10.0
target: mediatek/filogic
arch: aarch64_cortex-a53
kernel: 6.6.73
device: Xiaomi Mi Router AX3000T
```

Если версия kernel отличается, особенно `6.6.73`, пакет `kmod-amneziawg` нужно пересобрать.

## Установка

Скопировать на роутер:

```powershell
scp -O packages/openwrt-24.10.0-mediatek-filogic-kernel-6.6.73/*.ipk root@192.168.1.1:/tmp/
```

На роутере:

```sh
opkg install /tmp/kmod-amneziawg_6.6.73.1.0.20260611-r1_aarch64_cortex-a53.ipk
opkg install /tmp/amneziawg-tools_1.0.20260618-2-r1_aarch64_cortex-a53.ipk
opkg install /tmp/luci-proto-amneziawg_0.0.1-1-r1_all.ipk

awg --version
modprobe amneziawg
find /lib/modules/$(uname -r) -name '*amnezia*' -o -name '*awg*'
```

Ожидаемо:

```text
amneziawg-tools v1.0.20260618-2
/lib/modules/6.6.73/amneziawg.ko
```
