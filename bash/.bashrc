#
# ~/.bashrc
#

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if [[ -z "$SSH_CONNECTION" && -z "$TMUX" ]] && uwsm check may-start; then
	exec uwsm start hyprland.desktop
fi

# Supress weird OSC sequence that keeps displaying when opening tmux
if [[ -n "$TMUX" ]]; then
  printf '\033]11;#000000\007' >/dev/null
fi

# Java bullshit
export _JAVA_OPTIONS="-Xms512m -Xmx2g"
