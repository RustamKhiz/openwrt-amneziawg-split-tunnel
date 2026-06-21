#!/bin/sh

set -eu

ENV_FILE="${1:-/tmp/router.env}"

[ -f "$ENV_FILE" ] || {
    echo "Missing env file: $ENV_FILE" >&2
    exit 1
}

. "$ENV_FILE"

: "${AWG_PRIVATE_KEY:?}"
: "${AWG_SERVER_PUBLIC_KEY:?}"
: "${AWG_ENDPOINT_HOST:?}"
: "${AWG_ENDPOINT_PORT:?}"
: "${AWG_ADDR:?}"

AWG_MTU="${AWG_MTU:-1376}"

mkdir -p /etc/amneziawg
cp "$ENV_FILE" /etc/amneziawg/router.env
chmod 600 /etc/amneziawg/router.env

cat > /etc/amneziawg/awg0.conf <<EOF
[Interface]
PrivateKey = ${AWG_PRIVATE_KEY}
Jc = ${AWG_JC}
Jmin = ${AWG_JMIN}
Jmax = ${AWG_JMAX}
S1 = ${AWG_S1}
S2 = ${AWG_S2}
S3 = ${AWG_S3}
S4 = ${AWG_S4}
H1 = ${AWG_H1}
H2 = ${AWG_H2}
H3 = ${AWG_H3}
H4 = ${AWG_H4}

[Peer]
PublicKey = ${AWG_SERVER_PUBLIC_KEY}
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = ${AWG_ENDPOINT_HOST}:${AWG_ENDPOINT_PORT}
PersistentKeepalive = 25
EOF

chmod 600 /etc/amneziawg/awg0.conf

cp /tmp/amneziawg-router.init /etc/init.d/amneziawg-router
cp /tmp/update-awg-domains /usr/bin/update-awg-domains
cp /tmp/40-awg-split.nft /usr/share/nftables.d/ruleset-post/40-awg-split.nft
cp /tmp/awg-domains.list /etc/awg-domains.list

chmod +x /etc/init.d/amneziawg-router
chmod +x /usr/bin/update-awg-domains

/etc/init.d/amneziawg-router enable
/etc/init.d/amneziawg-router restart
/etc/init.d/firewall restart

/usr/bin/update-awg-domains || true

grep -q update-awg-domains /etc/crontabs/root 2>/dev/null || \
    echo '*/5 * * * * /usr/bin/update-awg-domains >/dev/null 2>&1' >> /etc/crontabs/root

/etc/init.d/cron enable
/etc/init.d/cron restart

echo "Installed. Check:"
echo "  awg show awg0"
echo "  ping -I awg0 -c 3 1.1.1.1"
echo "  nft list set inet fw4 awg_domains | head -80"
