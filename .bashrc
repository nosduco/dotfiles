# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:"$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.config/composer/vendor/bin"
export JDK_HOME="/usr/lib/jvm/java-13-openjdk"
export EDITOR=vim

alias svim='sudo -E vim'
alias ll='ls -l' 
alias la='ls -al'
alias ls='lsd'
alias fucking='sudo'
alias aur='yay'
alias fs='nautilus . &'
alias grep='grep --color=always'
alias windows='sudo grub-reboot 1 && sudo reboot'

# C - Hunter Support
export HUNTER_ROOT=$HOME/.hunter

# Android Studio
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

eval $(dircolors -b $HOME/.dircolors)
