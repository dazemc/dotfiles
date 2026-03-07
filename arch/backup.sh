#!/bin/bash
rm pkglist.txt foreignpkglist.txt
pacman -Qqe >pkglist.txt && pacman -Qqem >foreignpkglist.txt
sed -i '/^aura/d' ./foreignpkglist.txt
