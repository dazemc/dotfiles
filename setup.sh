#!/bin/bash

echo "Deleting pre-existing config"
rm -rf ~/.bashrc && rm -rf ~/.config/nvim && rm -rf ~/.tmux* && rm -rf ~/.config/spotify-player
echo "Linking bash config"
ln -s "$PWD"/bash/.bashrc ~/.bashrc
echo "Linking tmux configs"
ln -s "$PWD"/tmux/.* ~/
echo "Linking nvim configs"
ln -s "$PWD"/nvim ~/.config/
echo "Linking spotify-player configs"
ln -s "$PWD"/spotify-player ~/.config/
# sudo
sudo sh -c '
rm -rf /etc/ssh/ssh_config* /etc/ssh/sshd_config* /etc/pam.d/sshd /root/.config/nvim;
ln -s $PWD/private/ssh/* /etc/ssh/;
ln -s $PWD/private/pam.d/sshd /etc/pam.d/sshd;
ln -s $PWD/nvim /root/.config/nvim;
if grep -qi "arch" /etc/os-release; then
    echo "Arch Linux detected"
    sh $PWD/private/pacman/restore.sh
fi
'
