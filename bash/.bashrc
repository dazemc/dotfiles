#
# ~/.bashrc
#
# ENVAR
export TMUX_PLUGIN_MANAGER_PATH=~/.tmux/plugins/
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
# Java bullshit
export _JAVA_OPTIONS="-Xms512m -Xmx2g"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ALIAS
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias neofetch='clear && neofetch'
alias htop='btop'
alias pacconfig='sudo pacman -Qii | awk "/\[modified\]/ {print $(NF - 1)}"'
alias pacback='pacman -Qqen > pkglist.txt'
alias sourcebash='source ~/.bashrc'
# HYPRLAND
if [[ -z "$SSH_CONNECTION" && -z "$TMUX" ]] && uwsm check may-start; then
	exec uwsm start hyprland.desktop
fi

