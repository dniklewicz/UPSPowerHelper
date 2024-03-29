#!/bin/sh

## Prevent the execution of the script if the user has root privileges
if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root or sudo" 1>&2
  exit 1
fi

PORT=${1:-58879}

BINDIR=$HOME/.upspowerhelper
FILENAME=upspowerhelper.py

mkdir -p "$BINDIR"

XML="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.dniklewicz.UPSPowerHelper</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>$BINDIR/$FILENAME</string>
        <string>-p $PORT</string>
    </array>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/UPSPowerHelper-Error.log</string>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/UPSPowerHelper-Output.log</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>"

LAUNCHITEM="$HOME/Library/LaunchAgents/com.dniklewicz.UPSPowerHelper.plist"
URL="https://raw.githubusercontent.com/dniklewicz/UPSPowerHelper/master/src/upspowerHelper_localonly.py"

# Creating ~/Library/LaunchAgents if needed
LIB_LAUNCH_AGENTS="$HOME/Library/LaunchAgents/"

if [ ! -d "$LIB_LAUNCH_AGENTS" ]
then
  echo "Creating directory $LIB_LAUNCH_AGENTS"
  mkdir -p "$LIB_LAUNCH_AGENTS"
else
  echo "Directory $LIB_LAUNCH_AGENTS already exists"
fi

curl -L "$URL" --output "$FILENAME"
mv "$FILENAME" "$BINDIR/$FILENAME"
chmod +x "$BINDIR/$FILENAME"
echo $XML > "$LAUNCHITEM"
if (( `launchctl list | grep com.dniklewicz.UPSPowerHelper | wc -l` > 0 ))
then
  echo "Unloading previous instance of Power Server."
  launchctl unload -w "$LAUNCHITEM"
fi
launchctl load -w "$LAUNCHITEM"
# launchctl start "$LAUNCHITEM"

echo "Starting power server on port $PORT"
