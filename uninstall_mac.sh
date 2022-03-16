#!/bin/sh

BINDIR=$HOME/.upspowerhelper
FILENAME=upspowerhelper.py

LAUNCHITEM="$HOME/Library/LaunchAgents/com.dniklewicz.UPSPowerHelper.plist"
LOGFILE="$HOME/Library/Logs/UPSPowerHelper.log"

echo "Stopping power server on port."

rm -R "$BINDIR"
launchctl unload -w "$LAUNCHITEM"
rm "$LAUNCHITEM"
rm "$LOGFILE"


