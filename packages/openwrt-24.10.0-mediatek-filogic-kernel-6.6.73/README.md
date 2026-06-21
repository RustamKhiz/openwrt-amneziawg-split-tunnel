# OpenWrt 24.10.0 mediatek/filogic kernel 6.6.73

Готовые пакеты AmneziaWG v2 для Xiaomi Mi Router AX3000T на OpenWrt 24.10.0.

## Файлы

```text
kmod-amneziawg_6.6.73.1.0.20260611-r1_aarch64_cortex-a53.ipk
amneziawg-tools_1.0.20260618-2-r1_aarch64_cortex-a53.ipk
luci-proto-amneziawg_0.0.1-1-r1_all.ipk
```

## Важно

`kmod-amneziawg` собран строго под kernel `6.6.73`. На другом kernel ставить его не стоит.

Проверить kernel роутера:

```sh
uname -r
```

Проверить target:

```sh
ubus call system board
```
