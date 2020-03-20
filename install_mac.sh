#!/bin/sh

PORT=${1:-58879}

echo "Starting power server on port $PORT"

BINDIR=/usr/local/bin
FILENAME=upspowerhelper.py

XML="<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"> \
<plist version=\"1.0\"> \
<dict> \
    <key>Label</key> \
    <string>com.dniklewicz.UPSPowerHelper</string> \
    <key>ProgramArguments</key> \
    <array> \
        <string>/usr/bin/python2</string> \
        <string>$BINDIR/$FILENAME</string> \
        <string>-p $PORT</string> \
    </array> \
    <key>StandardErrorPath</key> \
    <string>$HOME/Library/Logs/UPSPowerHelper.log</string> \
    <key>StandardOutPath</key> \
    <string>$HOME/Library/Logs/UPSPowerHelper.log</string> \
    <key>RunAtLoad</key> \
    <true/> \
    <key>KeepAlive</key> \
    <true/> \
</dict> \
</plist>"

LAUNCHITEM="$HOME/Library/LaunchAgents/com.dniklewicz.UPSPowerHelper.plist"
URL="https://github.com/dniklewicz/UPSPowerHelper/releases/download/1.2/upspowerHelper.py"

curl -L "$URL" --output "$FILENAME"
mv "$FILENAME" "$BINDIR/$FILENAME"
echo $XML > "$LAUNCHITEM"
launchctl unload -w "$LAUNCHITEM"
launchctl load -w "$LAUNCHITEM"
# launchctl start "$LAUNCHITEM"
