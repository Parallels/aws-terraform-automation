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

if [ -z "$UBUNTU_VERSION" ]; then
  UBUNTU_VERSION="22.04.3"
fi

if [ -z "$MACHINE_NAME" ]; then
  MACHINE_NAME="Ubuntu Server $UBUNTU_VERSION"
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

cd $USER_FOLDER/code/packer-examples/ubuntu

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
    rm ubuntu.pkrvars.hcl
  fi

  echo "Initializing the packer project"
  /opt/homebrew/bin/packer init .

  echo "version      = \"$UBUNTU_VERSION\"
  machine_name = \"$MACHINE_NAME-$i\"
  hostname     = \"ubuntu-22-04-3-$i\"
  machine_specs = {
    cpus      = $CPU_COUNT,
    memory    = $MEM_SIZE,
    disk_size = \"$DISK_SIZE\",
  }
  create_vagrant_box = false" >ubuntu.pkrvars.hcl

  echo "Building the virtual machine"
  /opt/homebrew/bin/packer build -var-file=ubuntu.pkrvars.hcl .

  packer_build_exit_code=$?
  if [ $packer_build_exit_code -ne 0 ]; then
    exit $packer_build_exit_code
  fi

  echo "Creating a directory for the virtual machine"
  # Creating a directory for the virtual machine
  mv "$USER_FOLDER/code/packer-examples/ubuntu/out/$MACHINE_NAME-$i.pvm" "$USER_FOLDER/Parallels"

  echo "Registering the virtual machine"
  /usr/local/bin/prlctl register $USER_FOLDER/Parallels/$MACHINE_NAME-$i.pvm

  echo "Starting the virtual machine"
  /usr/local/bin/prlctl start "$MACHINE_NAME-$i"
done

echo "Cleaning up"
rm -rf ~/code
if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi
