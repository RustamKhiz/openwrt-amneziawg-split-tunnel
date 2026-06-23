#!/bin/sh

set -eu

CONTAINER="${CONTAINER:-amnezia-awg2}"
IFACE="${IFACE:-awg0}"

ROUTER_PUBLIC_KEY="${1:?Usage: add-router-peer.sh ROUTER_PUBLIC_KEY [ALLOWED_IP]}"
ALLOWED_IP="${2:-10.8.1.3/32}"
CONF="${CONF:-/opt/amnezia/awg/awg0.conf}"

docker exec "$CONTAINER" awg set "$IFACE" peer "$ROUTER_PUBLIC_KEY" allowed-ips "$ALLOWED_IP"
docker exec "$CONTAINER" sh -c "grep -q '$ROUTER_PUBLIC_KEY' '$CONF' || cat >> '$CONF' <<EOF

[Peer]
PublicKey = $ROUTER_PUBLIC_KEY
AllowedIPs = $ALLOWED_IP
EOF"
docker exec "$CONTAINER" awg show
