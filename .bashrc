#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias 144='bash ~/Scripts/144.sh'
alias sooth='bash ~/Scripts/sidetonesooth.sh'
PS1='[\u@\h \W]\$ '

export PATH=$PATH:$HOME"/Android/Sdk/platform-tools:/home/tony/.yarn/bin:$HOME/.cargo/bin"

alias svim='sudo vim -u ~/.vimrc'
alias ll='ls -l' 
alias la='ls -al'
alias fucking='sudo'
alias t='todo.sh'
alias windows='sudo grub-reboot 1 && sudo reboot'
alias stdlinux='ssh duco.5@stdlinux.cse.ohio-state.edu'
#old :( alias aur='pacaur --color=auto'
alias aur='yay'
alias yaourt='aur'
alias unitydebug='adb logcat -s Unity PackageManager dalvikvm DEBUG'
alias js='cd /home/tony/School/JuniorYearCSE && ls'
alias fs='nautilus . &'
alias gc='git commit -S -m'

eval $(dircolors -b $HOME/.dircolors)
