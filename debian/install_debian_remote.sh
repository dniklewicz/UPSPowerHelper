#!/bin/sh

PORT=${1:-58879}

BINDIR=/usr/bin/upspowerhelper
FILENAME=upspowerhelper.py

mkdir -p "$BINDIR"

LAUNCH_SCRIPT="python \"$BINDIR/$FILENAME\" -p $PORT"

LAUNCHITEM="/etc/init.d/ups-power-helper"
URL="https://raw.githubusercontent.com/dniklewicz/UPSPowerHelper/master/debian/src/upspowerHelper_debian_remote.py"

curl -L "$URL" --output "$FILENAME"
mv "$FILENAME" "$BINDIR/$FILENAME"
echo $LAUNCH_SCRIPT > "$LAUNCHITEM"
chmod +x "$LAUNCHITEM"

echo "Installed power server on port $PORT"
echo "Please reboot your system."


/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dniklewicz/UPSPowerHelper/master/debian/install_debian_remote.sh)"