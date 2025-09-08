#!/usr/bin/env bash

<<<<<<< Updated upstream
echo "Deleting pre-existing config"
rm -rf ~/.bashrc && rm -rf ~/.config/nvim && rm -rf ~/.tmux* && rm -rf ~/.config/spotify-player
echo "Linking bash config"
ln -s "$PWD"/bash/.bashrc ~/.bashrc
echo "Linking tmux configs"
ln -s "$PWD"/tmux/.* ~/
echo "Linking nvim configs"
ln -s "$PWD"/nvim ~/.config/
echo "Linking spotify-player configs"
ln -s "$PWD"/spotify-player ~/.config/
# sudo
sudo sh -c '
rm -rf /etc/ssh/ssh_config* /etc/ssh/sshd_config* /etc/pam.d/sshd /root/.config/nvim;
cp -rf $PWD/private/ssh/* /etc/ssh/;
ln -s $PWD/private/pam.d/sshd /etc/pam.d/sshd;
mkdir -p /root/.config/nvim;
ln -s $PWD/nvim /root/.config/nvim;
if grep -qi "arch" /etc/os-release; then
    echo "Arch Linux detected"
    sh $PWD/private/pacman/restore.sh
fi
'
=======
CONFIG_LIST=(
  "bash"
  "tmux"
  "neovim"
  "spotify"
)

CONFIG_PREPARE=(
  "$HOME/.bashrc"
  "$HOME/.tmux"
  "$HOME/.tmux.conf"
  "$HOME/.config/nvim/"
  "$HOME/.config/spotify-player/"
)

function deleteIfFileOrDir() {
  #TODO: backup
  if [ -f "$1" ]; then
    echo "Deleting pre-existing configuration files for: $1"
    rm -rf "$1"
  elif [ -d "$1" ]; then
    echo "Deleting pre-existing configuration directories for: $1"
    rm -rf "$1"
  fi
}

function prepareConfigLocation() {
  echo "Preparing configuration at $config"
  if [ -f "$1" ]; then
    touch "$1"
  elif [ -d "$1" ]; then
    mkdir -p "$1"
  fi
}

function clearExistingConfig {
  for config in "${CONFIG_PREPARE[@]}"; do
    deleteIfFileOrDir "$config"
    prepareConfigLocation "$config"
  done
}

function linkDirectories {
  for config in "${CONFIG_LIST[@]}"; do
    echo "Linking configuration for $config"
    case $config in
    "bash")
      ln -s "$PWD/bash/.bashrc" "$HOME/.bashrc"
      ;;
    "neovim")
      ln -s "$PWD/nvim" "$HOME/.config/"
      ;;
    "tmux")
      ln -s "$PWD"/tmux/.* "$HOME/"
      ;;
    "spotify")
      ln -s "$PWD/spotify-player/" "$HOME/.config/"
      ;;
    esac
  done
}

function runPrivateScript {
  sudo sh -c './private/setup.sh'
}

function postSetup {
  # shellcheck source=/dev/null
  source ~/.bashrc
  # TODO: symlink nvim user config+packages to root rather than having two seperate installs
  # possibly need to sync it instead because there may be permission issues with package updates/installs.
}

function main {
  clearExistingConfig
  linkDirectories
  runPrivateScript
  postSetup
  exit 0
}

main
>>>>>>> Stashed changes
