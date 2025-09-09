#!/usr/bin/env bash

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
