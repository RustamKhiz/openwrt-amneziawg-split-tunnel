# Quickstart: ручная установка

Этот путь повторяет рабочую схему без лишней автоматизации.

## 1. Проверить роутер

На OpenWrt:

```sh
ubus call system board
uname -r
opkg print-architecture
```

Для готовых пакетов из этого kit ожидается:

```text
OpenWrt 24.10.0
target mediatek/filogic
kernel 6.6.73
arch aarch64_cortex-a53
```

Если kernel другой, `kmod-amneziawg` нужно пересобрать.

## 2. Установить пакеты

Скопировать `.ipk` на роутер в `/tmp`, затем:

```sh
opkg install /tmp/kmod-amneziawg_*.ipk
opkg install /tmp/amneziawg-tools_*.ipk
opkg install /tmp/luci-proto-amneziawg_*.ipk

awg --version
modprobe amneziawg
find /lib/modules/$(uname -r) -name '*amnezia*' -o -name '*awg*'
```

## 3. Получить реальные параметры сервера

На сервере с Amnezia:

```sh
docker ps --format "table {{.Names}}\t{{.Ports}}"
docker exec amnezia-awg2 awg show
docker exec amnezia-awg2 sh -c "sed -E 's/(PrivateKey|PresharedKey) = .*/\1 = ***/' /opt/amnezia/awg/awg0.conf"
```

Нужны:

- public key сервера;
- endpoint IP/порт;
- `Jc/Jmin/Jmax`;
- `S1/S2/S3/S4`;
- `H1/H2/H3/H4`;
- адрес клиента, например `10.8.1.3/32`;
- private key роутера;
- public key роутера.

Если Amnezia Client выдал устаревший endpoint/порт, верь `docker ps` и `/opt/amnezia/awg/awg0.conf`.

## 4. Добавить peer роутера на сервер

На сервере:

```sh
docker exec amnezia-awg2 awg set awg0 peer '<ROUTER_PUBLIC_KEY>' allowed-ips 10.8.1.3/32
docker exec amnezia-awg2 awg show
```

Чтобы закрепить peer после рестарта контейнера, добавь его в `/opt/amnezia/awg/awg0.conf`.

## 5. Создать конфиг роутера

На роутере:

```sh
mkdir -p /etc/amneziawg
vi /etc/amneziawg/awg0.conf
chmod 600 /etc/amneziawg/awg0.conf
```

Шаблон: [templates/awg0.conf.example](templates/awg0.conf.example).

Важно: если на сервере `I1-I5` закомментированы, не добавляй их в конфиг роутера.

## 6. Установить init-скрипт

```sh
scp -O scripts/router/amneziawg-router.init root@192.168.1.1:/tmp/amneziawg-router
```

На роутере:

```sh
cp /tmp/amneziawg-router /etc/init.d/amneziawg-router
chmod +x /etc/init.d/amneziawg-router
/etc/init.d/amneziawg-router enable
/etc/init.d/amneziawg-router restart

awg show awg0
ping -I awg0 -c 3 1.1.1.1
```

## 7. Настроить split tunneling

Скопировать файлы:

```sh
scp -O scripts/router/40-awg-split.nft root@192.168.1.1:/tmp/
scp -O scripts/router/update-awg-domains root@192.168.1.1:/tmp/
scp -O templates/awg-domains.list.example root@192.168.1.1:/tmp/awg-domains.list
```

На роутере:

```sh
cp /tmp/40-awg-split.nft /usr/share/nftables.d/ruleset-post/40-awg-split.nft
cp /tmp/update-awg-domains /usr/bin/update-awg-domains
cp /tmp/awg-domains.list /etc/awg-domains.list
chmod +x /usr/bin/update-awg-domains

/etc/init.d/firewall restart
/usr/bin/update-awg-domains
nft list set inet fw4 awg_domains | head -80
```

Cron:

```sh
grep -q update-awg-domains /etc/crontabs/root || echo '*/5 * * * * /usr/bin/update-awg-domains >/dev/null 2>&1' >> /etc/crontabs/root
/etc/init.d/cron enable
/etc/init.d/cron restart
```

## 8. Проверить

С клиента за роутером открой нужный сервис. На роутере:

```sh
awg show awg0
nft list set inet fw4 awg_domains | head -120
```

Если `transfer` растет, сервис идет через VPN.
