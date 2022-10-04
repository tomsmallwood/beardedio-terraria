#!/bin/bash
set -euo pipefail

CMD="./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt -world /config/$world"

echo "Starting container, CMD: $CMD $@"
exec $CMD $@
