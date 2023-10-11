#!/bin/bash

function enable_screen_sharing() {
  echo "Enabling screen sharing"
  sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
  sudo /usr/bin/dscl . -passwd /Users/ec2-user parallels $VNC_USER_PASSWORD
}

#check if export.sh exists
if [ -f ./export.sh ]; then
  echo "export.sh file exists, setting the environment variables"
  chmod +x ./export.sh
  source ./export.sh
fi

enable_screen_sharing
if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi