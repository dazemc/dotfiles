#!/bin/bash
echo "Deleting pre-existing config"
rm -rf ~/.bashrc && rm -rf ~/.config/nvim && rm -rf ~/.tmux*
echo "Linking bash config"
cp -L ./bash/.bashrc ~/.bashrc
echo "Linking tmux configs"
cp -rL ./tmux/.* ~/
echo "Linking nvim configs"
cp -rL ./nvim ~/.config/
