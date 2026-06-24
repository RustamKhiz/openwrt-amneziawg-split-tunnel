# Сервисы и домены

Основной список лежит в:

```text
/etc/awg-domains.list
```

В репозитории шаблон:

```text
templates/awg-domains.list.example
```

После изменения:

```sh
sort -u /etc/awg-domains.list -o /etc/awg-domains.list
/usr/bin/update-awg-domains
nft list set inet fw4 awg_domains | head -120
```

## Упрощенное добавление

На роутер можно установить helper:

```sh
scp -O scripts/router/awg-add root@192.168.1.1:/tmp/awg-add
cp /tmp/awg-add /usr/bin/awg-add
chmod +x /usr/bin/awg-add
```

Использование:

```sh
awg-add youtube instagram telegram chatgpt
awg-add https://example.com/some/page
awg-add example.org
```

Команда сама:

- определяет известный сервис или домен;
- добавляет домены в `/etc/awg-domains.list`;
- убирает дубли;
- запускает `/usr/bin/update-awg-domains`;
- показывает preview nft-set.

Для сложных сервисов лучше использовать имя сервиса, а не только URL. Например:

```sh
awg-add instagram
```

добавит не только `instagram.com`, но и CDN-домены Meta.

## Особые случаи

### Telegram

Добавлены IP-сети:

```text
91.108.4.0/22
91.108.8.0/22
91.108.12.0/22
91.108.16.0/22
91.108.20.0/22
91.108.56.0/22
149.154.160.0/20
```

### Meta / Instagram / Facebook

Для медиа могут понадобиться IP-сети Meta. Они добавлены в `update-awg-domains`.

### YouTube

Видео часто идет через динамические `*.googlevideo.com`. Если видео не грузится, проверь DNS клиента и наполнение `awg_domains`.
