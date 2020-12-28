# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:"$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.config/composer/vendor/bin:$HOME/go/bin"
export JDK_HOME="/usr/lib/jvm/java-13-openjdk"
export EDITOR=vim


# C - Hunter Support
export HUNTER_ROOT=$HOME/.hunter

# Android Studio
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$(ruby -e 'puts Gem.user_dir')/bin

# Abstra
export ABSTRA_GITLAB_TOKEN=pTQUUHqtmoaYxdbGqGXn
export ARMSRC_GITLAB_TOKEN=YDjp9sZxUpJ-6v5hzdJm

eval $(dircolors -b $HOME/.dircolors)

# Aliases
alias svim='sudo -E vim'
alias ls='lsd'
alias ll='ls -l' 
alias lla='ls -la'
alias la='ls -a'
alias lt='ls --tree'
alias fucking='sudo'
alias aur='yay'
alias fs='nautilus . &'
alias androidem='/opt/android-sdk/emulator/emulator @$(/opt/android-sdk/emulator/emulator -list-avds)'
alias grep='grep --color=always'
alias windows='sudo grub-reboot 1 && sudo reboot'
alias we='curl wttr.in\?0nqF'
