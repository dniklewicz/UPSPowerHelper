#!/bin/sh

BINDIR=$HOME/.upspowerhelper
FILENAME=upspowerhelper.py

LAUNCHITEM="/etc/init.d/ups-power-helper"

echo "Stopping power server."

$LAUNCHITEM stop

update-rc.d -f ups-power-helper remove

rm "$BINDIR/$FILENAME"
rm "$LAUNCHITEM"

echo "Please reboot your system."
