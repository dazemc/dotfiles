#!/usr/bin/env bash

CONFIG_LIST=(
  "bash"
  "tmux"
  "neovim"
  "spotify"
  "msmtp"
  "hyprland"
  "quickshell"
  "enviroment.d"
  "zsh"
)

# do not leave a trailing slash as that will resolve the symlink back to the dotfiles dir
CONFIG_LOCATION=(
  "$HOME/.bashrc"
  "$HOME/.zshrc"
  "$HOME/.tmux"
  "$HOME/.tmux.conf"
  "$HOME/.config/nvim"
  "$HOME/.config/spotify-player"
  "$HOME/.config/msmtp"
  "$HOME/.config/hypr"
  "$HOME/.config/quickshell"
  "$HOME/.config/enviroment.d/"
)

# setup.sh links per-OS config: this workstation is Arch Linux, while
# shell/zsh/.zshrc is macOS-only (Homebrew paths). Detect the OS once so
# each link step can decide what applies.
OS="$(uname -s)"

function setGitGlobals {
  git config --global user.email "daazedjmcfarland@gmail.com"
  git config --global user.name "Daazed J McFarland"

}

# setup.sh deletes and relinks live paths (plus a sudo private script).
# It runs only with the user's explicit go-ahead in chat — never as
# verification for another step.
function clearExistingConfig {
  local backup_dir
  backup_dir="$HOME/.config/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup_dir"
  echo "Backing up existing config to: $backup_dir"
  for config in "${CONFIG_LOCATION[@]}"; do
    if [[ -e "$config" || -L "$config" ]]; then
      echo "Moving: $config -> $backup_dir/"
      mv "$config" "$backup_dir/"
    else
      echo "Skipping (not present): $config"
    fi
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
      ln -s "$PWD/tmux/.tmux" "$HOME/.tmux"
      ln -s "$PWD/tmux/.tmux.conf" "$HOME/.tmux.conf"
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
    "quickshell ")
      ln -s "$PWD/quickshell/" "$HOME/.config/"
      ;;
    "environment.d")
      ln -s "$PWD/environment.d/" "$HOME/.config"
      ;;
    "zsh")
      # .zshrc is macOS-only; skip it on Linux.
      if [[ "$OS" == "Darwin" ]]; then
        ln -s "$PWD/shell/zsh/.zshrc" "$HOME/.zshrc"
      else
        echo "Skipping zsh config (macOS-only, OS=$OS)"
      fi
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
