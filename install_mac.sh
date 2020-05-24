#!/bin/sh

PORT=${1:-58879}

echo "Starting power server on port $PORT"

BINDIR=/usr/local/bin
FILENAME=upspowerhelper.py

XML="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n\
<plist version=\"1.0\">\n\
<dict>\n\
    <key>Label</key>\n\
    <string>com.dniklewicz.UPSPowerHelper</string>\n\
    <key>ProgramArguments</key>\n\
    <array>\n\
        <string>/usr/bin/python</string>\n\
        <string>$BINDIR/$FILENAME</string>\n\
        <string>-p $PORT</string>\n\
    </array>\n\
    <key>StandardErrorPath</key>\n\
    <string>$HOME/Library/Logs/UPSPowerHelper.log</string>\n\
    <key>StandardOutPath</key>\n\
    <string>$HOME/Library/Logs/UPSPowerHelper.log</string>\n\
    <key>RunAtLoad</key>\n\
    <true/>\n\
    <key>KeepAlive</key>\n\
    <true/>\n\
</dict>\n\
</plist>"

LAUNCHITEM="$HOME/Library/LaunchAgents/com.dniklewicz.UPSPowerHelper.plist"
URL="https://github.com/dniklewicz/UPSPowerHelper/releases/download/1.3/upspowerHelper.py"

curl -L "$URL" --output "$FILENAME"
mv "$FILENAME" "$BINDIR/$FILENAME"
echo $XML > "$LAUNCHITEM"
launchctl unload -w "$LAUNCHITEM"
launchctl load -w "$LAUNCHITEM"
# launchctl start "$LAUNCHITEM"
