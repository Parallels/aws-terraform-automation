#!/bin/bash

export PATH="/usr/local/bin:$PATH"
export USER_FOLDER=$(echo ~)
/Applications/Parallels\ Desktop.app/Contents/MacOS/Parallels\ Service service_restart

#check if export.sh exists
if [ -f ./export.sh ]; then
  echo "export.sh file exists, setting the environment variables"
  chmod +x ./export.sh
  source ./export.sh
fi

if [ -z "$MACHINE_NAME" ]; then
  MACHINE_NAME="MacOS"
fi

if [ -z "$MACHINE_COUNT" ]; then
  MACHINE_COUNT=1
fi

if [ $MACHINE_COUNT -eq 0 ]; then
  echo "MACHINE_COUNT is 0. Exiting..."
  exit 0
fi

echo "Creating a directory for the code"
# Creating a directory for the code
if [ ! -d "$USER_FOLDER/code" ]; then
  echo "Clone the packer-examples repo"
  mkdir $USER_FOLDER/code
  cd $USER_FOLDER/code

  # clonning the packer-examples repo
  git clone https://github.com/Parallels/packer-examples.git
fi

cd $USER_FOLDER/code/packer-examples/macos

# Loop over the number of machines specified by $MACHINE_COUNT
for ((i = 1; i <= $MACHINE_COUNT; i++)); do
  echo "Checking if the virtual machine $MACHINE_NAME-$i already exists"
  # Checking if the virtual machine already exists
  /usr/local/bin/prlctl list $MACHINE_NAME-$i
  prlctl_exit_code=$?
  if [ $prlctl_exit_code -eq 0 ]; then
    continue
  fi

  if [ -f ubuntu.pkrvars.hcl ]; then
    rm macos.pkrvars.hcl
  fi

  echo "Initializing the packer project"
  /opt/homebrew/bin/packer init .

  echo "machine_name  = \"$MACHINE_NAME-$i\"
  ipsw_url      = \"$IPSW_URL\"
  ipsw_checksum = \"$IPSW_CHECKSUM\"
  boot_wait     = \"12m\"
  create_vagrant_box = false" >macos.pkrvars.hcl

  echo "Building the virtual machine"
  /opt/homebrew/bin/packer build -var-file=macos.pkrvars.hcl .

  packer_build_exit_code=$?
  if [ $packer_build_exit_code -ne 0 ]; then
    exit $packer_build_exit_code
  fi

  echo "Creating a directory for the virtual machine"
  # Creating a directory for the virtual machine
  mv "$USER_FOLDER/code/packer-examples/macos/out/$MACHINE_NAME-$i.macvm" "$USER_FOLDER/Parallels"

  echo "Registering the virtual machine"
  /usr/local/bin/prlctl register $USER_FOLDER/Parallels/$MACHINE_NAME-$i.macvm

  echo "Starting the virtual machine"
  /usr/local/bin/prlctl start "$MACHINE_NAME-$i"
done

echo "Cleaning up"
rm -rf ~/code
if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi
