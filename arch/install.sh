#!/bin/bash

pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/aura.tar.gz
tar zxvf aura.tar.gz && cd aura
makepkg -i && cd ../
aura -A $(cat foreignpkglist.txt) --skippgpcheck
