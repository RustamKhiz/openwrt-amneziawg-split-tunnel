# OpenWrt AmneziaWG Split Tunnel

Практический kit для установки **AmneziaWG v2** на OpenWrt-роутер и раздельного туннелирования по сервисам.

Проверено на:

- Xiaomi Mi Router AX3000T
- OpenWrt `24.10.0`
- target `mediatek/filogic`
- arch `aarch64_cortex-a53`
- kernel `6.6.73`

Что получится:

- роутер поднимает AmneziaWG-интерфейс `awg0`;
- обычный интернет идет напрямую;
- выбранные сервисы идут через VPN;
- список сервисов редактируется в `/etc/awg-domains.list`;
- IP доменов обновляются автоматически через cron.

## Что нужно заранее

Это не подписка на чужой VPN. Нужен свой сервер/VPS, на который ставится Amnezia.

Минимально:

- VPS за пределами РФ или в нужной тебе стране;
- публичный IPv4;
- root-доступ по SSH или пользователь с sudo;
- Debian/Ubuntu на сервере;
- установленный Amnezia VPN Client на ПК;
- OpenWrt на роутере;
- доступ к роутеру по SSH.

Сначала в Amnezia Client добавляется свой сервер, Amnezia устанавливает на него AmneziaWG, и только потом этот репозиторий помогает подключить к этому серверу OpenWrt-роутер.

## Два варианта установки

### Вариант A: ручной

Максимально понятный и контролируемый путь. Рекомендуется для первой установки.

См. [QUICKSTART.md](QUICKSTART.md).

### Вариант B: полуавтоматический

Ты заполняешь `router.env`, копируешь файлы на роутер и запускаешь install-скрипт.

См. [docs/auto-install.md](docs/auto-install.md).

## Структура

```text
docs/                         Подробная документация
scripts/router/               Скрипты для OpenWrt
scripts/server/               Скрипты для сервера/SDK
templates/                    Шаблоны конфигов без секретов
packages/                     Место для .ipk пакетов
```

## Безопасность

Не коммить:

- `PrivateKey`;
- `PresharedKey`;
- реальные server/router env-файлы;
- реальные `.conf` с ключами.

Используй только `.example` шаблоны.

## Быстрая диагностика

На роутере:

```sh
awg show awg0
ping -I awg0 -c 3 1.1.1.1
ip rule | grep 100
ip route show table 100
nft list set inet fw4 awg_domains | head -80
```

Подробно: [docs/troubleshooting.md](docs/troubleshooting.md).

## Добавление сайтов в туннель

После установки helper-а:

```sh
awg-add youtube instagram telegram chatgpt
awg-add https://example.com/some/page
```

Для обычного сайта можно вставить ссылку. Для сложных сервисов лучше использовать готовый профиль сервиса.
