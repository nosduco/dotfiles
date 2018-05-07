#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias svim='sudo vim -u ~/.vimrc'
alias ll='ls -l' 
alias la='ls -al'
alias fucking='sudo'
alias stdlinux='ssh duco.5@stdlinux.cse.ohio-state.edu'
alias aur='yay'
alias yaourt='aur'
alias unitydebug='adb logcat -s Unity PackageManager dalvikvm DEBUG'
export PATH="$PATH:/home/nos/Work/arc/arcanist/bin"
# source /home/nos/Work/arc/arcanist/resources/shell/bash-completion
