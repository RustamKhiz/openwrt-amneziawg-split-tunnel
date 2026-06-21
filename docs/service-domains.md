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
