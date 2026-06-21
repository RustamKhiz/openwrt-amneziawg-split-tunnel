# Prerequisites

Перед настройкой OpenWrt нужен свой VPN-сервер.

## Сервер/VPS

Нужен VPS с публичным IPv4. Обычно достаточно минимального тарифа:

- 1 vCPU;
- 512 MB - 1 GB RAM;
- 5-10 GB disk;
- Debian или Ubuntu;
- root SSH или sudo-доступ.

Лучше выбирать страну, из которой должны открываться нужные сервисы.

## Amnezia

На ПК установить Amnezia VPN Client и добавить сервер:

```text
Self-hosted VPN / свой сервер
IP сервера
SSH login
SSH password или SSH key
```

В Amnezia установить протокол:

```text
AmneziaWG
```

Проверить с телефона/ПК, что VPN работает, до настройки роутера.

## Что понадобится для роутера

С сервера нужны:

- имя Docker-контейнера AmneziaWG, обычно `amnezia-awg2`;
- внешний UDP-порт контейнера;
- server public key;
- параметры AmneziaWG v2: `Jc/Jmin/Jmax/S1/S2/S3/S4/H1-H4`;
- peer для роутера с отдельным адресом, например `10.8.1.3/32`.

Команды:

```sh
docker ps --format "table {{.Names}}\t{{.Ports}}"
docker exec amnezia-awg2 awg show
docker exec amnezia-awg2 sh -c "sed -E 's/(PrivateKey|PresharedKey) = .*/\1 = ***/' /opt/amnezia/awg/awg0.conf"
```

Не публикуй `PrivateKey` и `PresharedKey`.

## Роутер

Проверенная конфигурация:

```text
Xiaomi Mi Router AX3000T
OpenWrt 24.10.0
target mediatek/filogic
kernel 6.6.73
arch aarch64_cortex-a53
```

Проверка:

```sh
ubus call system board
uname -r
opkg print-architecture
```
