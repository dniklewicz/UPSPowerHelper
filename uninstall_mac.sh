#!/bin/sh

BINDIR=/usr/local/bin
FILENAME=upspowerhelper.py

LAUNCHITEM="$HOME/Library/LaunchAgents/com.dniklewicz.UPSPowerHelper.plist"

echo "Stopping power server on port."

rm "$BINDIR/$FILENAME"
launchctl unload -w "$LAUNCHITEM"
rm "$LAUNCHITEM"


