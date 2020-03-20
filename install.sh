#!/bin/sh

PORT=${1:-58879}

echo "Starting power server on port $PORT"

BIN=/usr/local/bin/upspowerhelper.py

XML="<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"> \
<plist version=\"1.0\"> \
<dict> \
    <key>Label</key> \
    <string>com.dniklewicz.UPSPowerHelper</string> \
    <key>ProgramArguments</key> \
    <array> \
        <string>/usr/bin/python2</string> \
        <string>$BIN</string> \
        <string>$PORT</string>
    </array> \
    <key>StandardErrorPath</key> \
    <string>/var/log/UPSPowerHelper.error</string> \
    <key>RunAtLoad</key> \
    <true/> \
    <key>KeepAlive</key> \
    <true/> \
</dict> \
</plist>"

LAUNCHITEM="~/Library/LaunchAgents/com.dniklewicz.UPSPowerHelper.plist"

cp UPSPowerHelper $BIN
echo $XML > $LAUNCHITEM
launchctl load $LAUNCHITEM
