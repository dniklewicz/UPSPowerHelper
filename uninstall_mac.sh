#!/bin/sh

BINDIR=$HOME/.upspowerhelper
FILENAME=upspowerhelper.py

LAUNCHITEM="$HOME/Library/LaunchAgents/com.dniklewicz.UPSPowerHelper.plist"
LEGACY_LOGFILE="$HOME/Library/Logs/UPSPowerHelper.log"
OUTPUT_LOGFILE="$HOME/Library/Logs/UPSPowerHelper-Output.log"
ERROR_LOGFILE="$HOME/Library/Logs/UPSPowerHelper-Error.log"

echo "Stopping power server..."

echo "Removing Power Server directory and files"
rm -R "$BINDIR"

echo "Unloading service from autostart"
launchctl unload -w "$LAUNCHITEM"

echo "Removing service descriptor"
rm "$LAUNCHITEM"

echo "Removing logs"
if [ -f "$LEGACY_LOGFILE" ]; then
  rm "$LEGACY_LOGFILE"
fi

if [ -f "$OUTPUT_LOGFILE" ]; then
  rm "$OUTPUT_LOGFILE"
fi

if [ -f "$ERROR_LOGFILE" ]; then
  rm "$ERROR_LOGFILE"
fi

echo "Done."

