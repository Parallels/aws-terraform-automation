# checking the type of cpu
cpu=$(sysctl -n machdep.cpu.brand_string)
if [[ $cpu == *"Apple"* ]]; then
  echo "Apple Silicon detected"
  # Installing parallels desktop using command line
  /opt/homebrew/bin/brew install parallels
  # Getting the latest ipsw file
  url=$(/Applications/Parallels\ Desktop.app/Contents/MacOS/prl_macvm_create --getipswurl)
  curl -o ~/ios.ipsw $url
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
