#!/bin/bash
function install_packer() {
  echo "Checking if packer is installed"
  which packer
  packer_exit_code=$?
  if [ $packer_exit_code -eq 0 ]; then
    echo "Packer is already installed"
    return
  fi

  echo "Installing packer"
  /opt/homebrew/bin/brew install packer
}

function install_git() {
  echo "Checking if git is installed"
  which git
  git_exit_code=$?
  if [ $git_exit_code -eq 0 ]; then
    echo "Git is already installed"
    return
  fi

  echo "Installing git"
  /opt/homebrew/bin/brew install git
}

function install_homebrew() {
  echo "Checking if homebrew is installed"
  which brew
  brew_exit_code=$?
  if [ $brew_exit_code -eq 0 ]; then
    echo "Homebrew is already installed"
    return
  fi

  echo "Installing homebrew"
  sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

#check if export.sh exists
if [ -f ~/export.sh ]; then
  echo "export.sh file exists, setting the environment variables"
  chmod +x ~/export.sh
  source ~/export.sh
fi

echo "Installing Dependencies"

install_homebrew
install_packer
install_git

if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi
