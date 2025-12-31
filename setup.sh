#!/usr/bin/env bash

CONFIG_LIST=(
  "bash"
  "tmux"
  "neovim"
  "spotify"
  "msmtp"
  "hyprland"
  "waybar"
)

# do not leave a trailing slash as that will resolve the symlink back to the dotfiles dir
CONFIG_LOCATION=(
  "$HOME/.bashrc"
  "$HOME/.tmux"
  "$HOME/.tmux.conf"
  "$HOME/.config/nvim"
  "$HOME/.config/spotify-player"
  "$HOME/.config/msmtp"
  "$HOME/.config/hypr"
  "$HOME/.config/waybar"
)

function setGitGlobals {
  git config --global user.email "daazedjmcfarland@gmail.com"
  git config --global user.name "Daazed J McFarland"

}

function clearExistingConfig {
  for config in "${CONFIG_LOCATION[@]}"; do
    echo "Deleting: $config"
    rm -rf "$config"
  done
}

function linkDirectories {
  ln -sf "$PWD/shell/.alias" "$HOME/.alias"
  for config in "${CONFIG_LIST[@]}"; do
    echo "Linking configuration for $config"
    case $config in
    "bash")
      ln -s "$PWD/shell/bash/.bashrc" "$HOME/.bashrc"
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
    "msmtp")
      mkdir -p "$HOME/.config/msmtp/"
      ln -s "$PWD/msmtp/config" "$HOME/.config/msmtp/"
      ;;
    "hyprland")
      ln -s "$PWD/hyprland/hypr/" "$HOME/.config/"
      ;;
    "waybar")
      ln -s "$PWD/waybar/" "$HOME/.config/"
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
  setGitGlobals
  clearExistingConfig
  linkDirectories
  runPrivateScript
  postSetup
  exit 0
}

main
