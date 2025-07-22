#!/bin/bash
#
echo "Deleting pre-existing config"
rm -rf ~/.bashrc && rm -rf ~/.config/nvim && rm -rf ~/.tmux*
echo "Linking bash config"
cp -l ./bash/.bashrc ~/.bashrc
echo "Linking tmux configs"
cp -rl ./tmux/.* ~/
echo "Linking nvim configs"
cp -rl ./nvim ~/.config/
#
sudo sh -c "
rm -rf /etc/ssh/ssh_config* /etc/ssh/sshd_config*;
cp -rlL ./private/ssh/* /etc/ssh/;
"
