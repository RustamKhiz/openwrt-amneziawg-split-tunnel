# Полуавтоматическая установка

Этот вариант раскладывает файлы на роутере и генерирует `/etc/amneziawg/awg0.conf` из `router.env`.

Перед этим должен быть подготовлен VPS с AmneziaWG. См. [prerequisites.md](prerequisites.md).

## 1. Подготовить env

```sh
cp templates/router.env.example router.env
```

Заполни `router.env`.

Не коммить `router.env`.

## 2. Скопировать на роутер

```sh
scp -O router.env root@192.168.1.1:/tmp/router.env
scp -O scripts/router/install-router-files.sh root@192.168.1.1:/tmp/install-router-files.sh
scp -O scripts/router/amneziawg-router.init root@192.168.1.1:/tmp/amneziawg-router.init
scp -O scripts/router/update-awg-domains root@192.168.1.1:/tmp/update-awg-domains
scp -O scripts/router/awg-add root@192.168.1.1:/tmp/awg-add
scp -O scripts/router/40-awg-split.nft root@192.168.1.1:/tmp/40-awg-split.nft
scp -O templates/awg-domains.list.example root@192.168.1.1:/tmp/awg-domains.list
```

OpenWrt часто не имеет `sftp-server`, поэтому для Windows OpenSSH нужен `scp -O`.

## 3. Запустить installer

На роутере:

```sh
sh /tmp/install-router-files.sh /tmp/router.env
```

## 4. Проверить

```sh
awg show awg0
ping -I awg0 -c 3 1.1.1.1
ip rule | grep 100
nft list set inet fw4 awg_domains | head -80
```

## Добавление сайтов и сервисов

После установки можно добавлять сервисы одной командой:

```sh
awg-add youtube instagram telegram chatgpt
awg-add https://example.com/some/page
```

## 5. Не забыть закрепить peer на сервере

На сервере:

```sh
scripts/server/add-router-peer.sh '<ROUTER_PUBLIC_KEY>' 10.8.1.3/32
```

Этот скрипт не только вызывает `awg set`, но и добавляет peer в `/opt/amnezia/awg/awg0.conf`, чтобы настройка пережила рестарт сервера.
