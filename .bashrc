# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:"/opt/android-sdk/platform-tools:$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.config/composer/vendor/bin"
export ANDROID_SDK_ROOT="/opt/android-sdk"
export ANDROID_SDK="/opt/android-sdk"
export JDK_HOME="/usr/lib/jvm/java-12-openjdk"

alias svim='sudo -E vim'
alias ll='ls -l' 
alias la='ls -al'
alias ls='lsd'
alias fucking='sudo'
alias aur='yay'
alias fs='nautilus . &'
alias androidem='/opt/android-sdk/emulator/emulator @$(/opt/android-sdk/emulator/emulator -list-avds)'
alias grep='grep --color=always'

# Anaconda - Data Mining
source /opt/anaconda/bin/activate root

# C - Hunter Support
export HUNTER_ROOT=$HOME/.hunter

eval $(dircolors -b $HOME/.dircolors)

# Web Apps Ruby
# eval "$(rbenv init -)"
