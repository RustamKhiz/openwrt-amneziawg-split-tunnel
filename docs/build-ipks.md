# Сборка .ipk пакетов

Нужна, если kernel/target отличается или пакетов нет в `packages/`.

## Зависимости на сервере

```sh
apt update
apt install -y build-essential clang flex bison g++ gawk gcc-multilib gettext git libncurses-dev libssl-dev python3 python3-dev python3-setuptools rsync unzip zlib1g-dev file wget zstd swig
```

## SDK для проверенного роутера

```sh
cd /root
wget https://downloads.openwrt.org/releases/24.10.0/targets/mediatek/filogic/openwrt-sdk-24.10.0-mediatek-filogic_gcc-13.3.0_musl.Linux-x86_64.tar.zst
tar --use-compress-program=unzstd -xf openwrt-sdk-24.10.0-mediatek-filogic_gcc-13.3.0_musl.Linux-x86_64.tar.zst
cd openwrt-sdk-24.10.0-mediatek-filogic_gcc-13.3.0_musl.Linux-x86_64
```

## Сборка

Используй скрипт:

```sh
scripts/server/build-openwrt-ipks.sh
```

или вручную повтори его шаги.

Ожидаемые файлы:

```text
kmod-amneziawg_6.6.73.1.0.20260611-r1_aarch64_cortex-a53.ipk
amneziawg-tools_1.0.20260618-2-r1_aarch64_cortex-a53.ipk
luci-proto-amneziawg_0.0.1-1-r1_all.ipk
```

`kmod-amneziawg` жестко привязан к версии kernel. После обновления OpenWrt его нужно пересобрать.
