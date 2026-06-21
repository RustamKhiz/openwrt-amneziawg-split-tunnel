#!/bin/sh

set -eu

CONTAINER="${1:-amnezia-awg2}"

docker ps --format "table {{.Names}}\t{{.Ports}}"
docker exec "$CONTAINER" awg show
docker exec "$CONTAINER" sh -c "sed -E 's/(PrivateKey|PresharedKey) = .*/\1 = ***/' /opt/amnezia/awg/awg0.conf"
