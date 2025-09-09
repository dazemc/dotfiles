#!/usr/bin/env bash

CONFIG_LIST=(
  "bash"
  "tmux"
  "neovim"
  "spotify"
)

CONFIG_LOCATION=(
  "$HOME/.bashrc"
  "$HOME/.tmux"
  "$HOME/.tmux.conf"
  "$HOME/.config/nvim"
  "$HOME/.config/spotify-player"
)

function clearExistingConfig {
  for config in "${CONFIG_LOCATION[@]}"; do
    echo "Deleting: $config"
    rm -rf "$config"
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
  sudo bash './private/setup.sh'
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
