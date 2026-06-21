#!/bin/sh

set -eu

FILE="${AWG_DOMAINS_FILE:-/etc/awg-domains.list}"

add_domains() {
    while [ "$#" -gt 0 ]; do
        echo "$1"
        shift
    done >> "$FILE"
}

touch "$FILE"

for service in "$@"; do
    case "$service" in
        telegram)
            add_domains telegram.org t.me telegram.me telegra.ph web.telegram.org api.telegram.org core.telegram.org desktop.telegram.org updates.tdesktop.com
            ;;
        youtube)
            add_domains youtube.com www.youtube.com m.youtube.com youtu.be youtubei.googleapis.com youtube.googleapis.com googlevideo.com redirector.googlevideo.com ytimg.com i.ytimg.com yt3.ggpht.com ggpht.com youtube-nocookie.com googleusercontent.com
            ;;
        chatgpt|openai|codex)
            add_domains chatgpt.com chat.openai.com chatgpt.livekit.cloud openai.com www.openai.com api.openai.com auth.openai.com platform.openai.com codex.openai.com cdn.oaistatic.com oaistatic.com files.oaiusercontent.com oaiusercontent.com ab.chatgpt.com ios.chat.openai.com android.chat.openai.com events.statsigapi.net featuregates.org
            ;;
        instagram|meta)
            add_domains instagram.com www.instagram.com i.instagram.com b.i.instagram.com graph.instagram.com api.instagram.com cdninstagram.com scontent.cdninstagram.com fbcdn.net fna.fbcdn.net facebook.com graph.facebook.com connect.facebook.net static.xx.fbcdn.net external.xx.fbcdn.net video.xx.fbcdn.net
            ;;
        discord)
            add_domains discord.com discord.gg discordapp.com discordapp.net cdn.discordapp.com media.discordapp.net
            ;;
        *)
            echo "Unknown service: $service" >&2
            exit 1
            ;;
    esac
done

sort -u "$FILE" -o "$FILE"
/usr/bin/update-awg-domains
