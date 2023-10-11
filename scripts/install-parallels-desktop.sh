#!/bin/bash

#check if export.sh exists
if [ -f ./export.sh ]; then
  echo "export.sh file exists, setting the environment variables"
  chmod +x ./export.sh
  source ./export.sh
fi

# Login in into parallels website
function login() {
  echo "Logging in into parallels website"
  echo $PARALLELS_USER_PASSWORD >~/parallels_password.txt
  /Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart
  /Applications/Parallels\ Desktop.app/Contents/MacOS/prlsrvctl web-portal signin $PARALLELS_USER_EMAIL --read-passwd ~/parallels_password.txt
  rm ~/parallels_password.txt
}

function install_key() {
  echo "Installing the key"
  /Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart
  /Applications/Parallels\ Desktop.app/Contents/MacOS/prlsrvctl install-license --key $PARALLELS_KEY --activate-online-immediately
}

function restart_service_on_login() {
  echo "Restarting the parallels service"
  echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
  grep -qxF '/Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart' ~/.zshrc || echo '/Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart' >>~/.zshrc
  source ~/.zshrc
}

#check if export.sh exists
if [ -f ./export.sh ]; then
  echo "export.sh file exists, setting the environment variables"
  chmod +x ./export.sh
  source ./export.sh
fi

which prlctl
prlctl_exit_code=$?
if [ $prlctl_exit_code -eq 0 ]; then
  echo "Parallels Desktop is already installed"
  if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi
  exit 0
fi

# checking the type of cpu
cpu=$(sysctl -n machdep.cpu.brand_string)
if [[ $cpu == *"Apple"* ]]; then
  echo "Apple Silicon detected"

  # Installing rosetta
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  # Installing parallels desktop using command line
  /opt/homebrew/bin/brew install parallels
  # Restarting the parallels service
  /Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart

  login
  install_key
else
  echo "Intel CPU detected"
  # Installing parallels desktop using command line
  /usr/local/bin/brew install parallels
  # TODO: Add the code to create two virtual machines
fi

restart_service_on_login
if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi