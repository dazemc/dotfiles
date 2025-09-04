#
# ~/.bashrc
#
# ENVAR
# shellcheck disable=SC1090
if [ -f ~/GitHub/dotfiles/private/bash/.env ]; then
  source ~/GitHub/dotfiles/private/bash/.env
fi
export TMUX_PLUGIN_MANAGER_PATH=~/.tmux/plugins/
export LANG=en_US.utf8
export LC_ALL=en_US.utf8
export LC_CTYPE=en_US.utf8
export LC_COLLATE=en_US.utf8
if [ -d "$HOME/.pub-cache/bin" ]; then
  export PATH="$PATH":"$HOME/.pub-cache/bin"
fi
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
alias shsrc='source ~/.bashrc'
alias realloc='sudo mount -o remount,size=100% /tmp'
alias dealloc='sudo mount -o remount,size=50% /tmp'
# shows all tracked configs for installed pacakges
alias pacconfig='sudo pacman -Qii | awk '\''/\[modified\]/ {print $(NF - 1)}'\'''
# backup pacman package list
alias pacback='pacman -Qqen > pkglist.txt'
alias spty='spotify_player'
alias idfstart=idfsource
alias lspread='sh ~/GitHub/dotfiles/bash/lsp_util.sh'
alias dotfiles='cd ~/GitHub/dotfiles/'
# BAT
alias man='batman'
alias batlsblk='lsblk | bat -l conf'
alias batfree='free -h | bat -l meminfo'
# HYPRLAND
if [[ -z "$SSH_CONNECTION" && -z "$TMUX" ]] && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi

# SOURCE
# ESP32
function idfsource() {
  sourceEsp32='/opt/esp-idf/export.sh'
  if [ -f $sourceEsp32 ]; then
    echo "Sourcing ESP32..."
    source /opt/esp-idf/export.sh
  else
    echo "ESP32 source missing"
  fi
}
