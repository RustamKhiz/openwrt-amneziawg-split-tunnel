# Troubleshooting

## Нет SSH на роутер

Проверь gateway:

```powershell
ipconfig
```

Обычно:

```powershell
ssh root@192.168.1.1
```

Не путать с `168.192.1.1`.

## `awg setconf`: `Line unrecognized: S3`

Старый `amneziawg-tools`. Нужна версия с поддержкой AmneziaWG v2:

```sh
awg --version
```

Рабочая версия:

```text
amneziawg-tools v1.0.20260618-2
```

## `awg setconf`: `Unable to modify interface: Invalid argument`

Userspace tools понимают параметр, но kernel module нет. Нужен свежий `kmod-amneziawg`.

Рабочий тег kernel module:

```text
v1.0.20260611
```

## Handshake нет, `0 B received`

Проверить:

```sh
awg show awg0
docker exec amnezia-awg2 awg show
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

Частые причины:

- неверный endpoint port;
- public key сервера не совпадает;
- peer роутера не добавлен на сервер;
- `PresharedKey` есть только на одной стороне;
- параметры `Jc/S/H/I` не совпадают с сервером.

## После рестарта сервера роутер перестал работать

Если Amnezia Client работает, а роутер нет, почти всегда пропал peer роутера на сервере.

Проверить на сервере:

```sh
docker exec amnezia-awg2 awg show
```

Должен быть peer роутера:

```text
peer: <ROUTER_PUBLIC_KEY>
allowed ips: 10.8.1.3/32
```

Если его нет, временно добавить:

```sh
docker exec amnezia-awg2 awg set awg0 peer '<ROUTER_PUBLIC_KEY>' allowed-ips 10.8.1.3/32
```

И обязательно закрепить в конфиге:

```sh
docker exec amnezia-awg2 sh -c '
grep -q "<ROUTER_PUBLIC_KEY>" /opt/amnezia/awg/awg0.conf || cat >> /opt/amnezia/awg/awg0.conf <<EOF

[Peer]
PublicKey = <ROUTER_PUBLIC_KEY>
AllowedIPs = 10.8.1.3/32
EOF
'
```

Причина: `awg set` меняет live-состояние интерфейса, но не редактирует `/opt/amnezia/awg/awg0.conf`.

## `ping -I awg0 1.1.1.1` работает, но сервис не идет через VPN

Проверить split set:

```sh
nft list set inet fw4 awg_domains
/usr/bin/update-awg-domains
```

На клиенте отключить Private DNS / DoH.

## Telegram не работает

Telegram часто использует IP-сети напрямую. Они должны быть добавлены в `update-awg-domains`.

## YouTube/Instagram грузят ленту, но не видео

Нужны CDN-домены и/или IP-сети CDN.

Проверить, растет ли трафик:

```sh
awg show awg0
```
