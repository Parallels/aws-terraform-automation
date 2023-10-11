#!/bin/bash

  # Getting the latest ipsw file
  if [ -f ~/ios.ipsw ]; then
    echo "ios.ipsw file exists, not downloading it again"
  else
    echo "ios.ipsw file does not exist, getting it from the internet"
    url=$(/Applications/Parallels\ Desktop.app/Contents/MacOS/prl_macvm_create --getipswurl)
    curl -o ~/ios.ipsw $url
  fi

  # Creating two virtual machines
  echo "Creating first virtual machine"
  /Applications/Parallels\ Desktop.app/Contents/MacOS/prl_macvm_create ~/ios.ipsw ~/macOS_1.macvm
  echo "Creating second virtual machine"
  /Applications/Parallels\ Desktop.app/Contents/MacOS/prl_macvm_create ~/ios.ipsw ~/macOS_2.macvm
  echo "Virtual machines created"