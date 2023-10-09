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
  grep -qxF '/Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart' ~/.zshrc || echo '/Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart' >>~/.zshrc
  source ~/.zshrc
}

#check if export.sh exists
if [ -f ./export.sh ]; then
  echo "export.sh file exists, setting the environment variables"
  chmod +x ./export.sh
  source ./export.sh
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
else
  echo "Intel CPU detected"
  # Installing parallels desktop using command line
  /usr/local/bin/brew install parallels
  # TODO: Add the code to create two virtual machines
fi

restart_service_on_login
