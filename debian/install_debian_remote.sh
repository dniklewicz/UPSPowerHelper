#!/bin/sh

PORT=${1:-58879}

BINDIR=/usr/bin/upspowerhelper
FILENAME=upspowerhelper.py

mkdir -p "$BINDIR"

LAUNCHITEM="/etc/init.d/ups-power-helper"
URL="https://raw.githubusercontent.com/dniklewicz/UPSPowerHelper/master/debian/src/upspowerHelper_debian_remote.py"

curl -L "$URL" --output "$FILENAME"
mv "$FILENAME" "$BINDIR/$FILENAME"

curl -L "https://raw.githubusercontent.com/dniklewicz/UPSPowerHelper/master/debian/ups-power-helper" --output "$LAUNCHITEM"
chmod +x "$LAUNCHITEM"

"$LAUNCHITEM" start

echo "Started power server on port $PORT"
