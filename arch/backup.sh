#!/bin/bash
rm pkglist.txt foreignpkglist.txt
pacman -Qqe >pkglist.txt && pacman -Qqem >foreignpkglist.txt
