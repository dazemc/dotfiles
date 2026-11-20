#!/usr/bin/env bash
# Install the curated package set from pkglist.txt and foreignpkglist.txt.
# Run as the normal user: pacman and makepkg both invoke sudo for installs,
# and makepkg refuses to run as root.
set -euo pipefail

cd "$(dirname "$0")" || exit 1

if [[ $EUID -eq 0 ]]; then
  echo "Run this as your normal user, not root (makepkg refuses root; sudo is used for pacman)." >&2
  exit 1
fi

mapfile -t packages < <(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
if ((${#packages[@]})); then
  sudo pacman -S --needed "${packages[@]}"
fi

# Build and install the AUR helper used for the foreign package list.
curl -fLO https://aur.archlinux.org/cgit/aur.git/snapshot/aura.tar.gz
tar -xzf aura.tar.gz
(cd aura && makepkg -si)

mapfile -t aur_packages < <(grep -v '^aura$' foreignpkglist.txt)
if ((${#aur_packages[@]})); then
  aura -A --needed "${aur_packages[@]}"
fi
