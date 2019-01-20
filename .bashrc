#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias 144='bash ~/Scripts/144.sh'

export PATH=$PATH:$HOME"/Android/Sdk/platform-tools:$HOME/.yarn/bin:$HOME/.cargo/bin"

alias svim='sudo vim -u ~/.vimrc'
alias ll='ls -l' 
alias la='ls -al'
alias fucking='sudo'
alias windows='sudo grub-reboot 1 && sudo reboot'
alias aur='yay'
alias unitydebug='adb logcat -s Unity PackageManager dalvikvm DEBUG'
alias fs='nautilus . &'

export HUNTER_ROOT=$HOME/.hunter

eval $(dircolors -b $HOME/.dircolors)
eval "$(rbenv init -)"
