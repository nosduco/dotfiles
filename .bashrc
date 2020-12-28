# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:"$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.config/composer/vendor/bin"
export JDK_HOME="/usr/lib/jvm/java-11-openjdk"
export EDITOR=vim

alias svim='sudo -E vim'
alias ll='ls -l' 
alias la='ls -al'
alias fucking='sudo'
alias aur='yay'
alias fs='nautilus . &'
alias grep='grep --color=always'
alias windows='sudo grub-reboot 1 && sudo reboot'
alias unitydebug='adb logcat -s Unity PackageManager dalvikvm DEBUG'

# Override rm for trash
alias rm=trash

# Override ls for lsd
alias ls=lsd

# C - Hunter Support
export HUNTER_ROOT=$HOME/.hunter

# Ruby
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH=$PATH:$GEM_HOME/bin

# Android Studio
export ANDROID_HOME=$HOME/Android/Sdk
# export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export ARMSRC_GITLAB_TOKEN=UCgLwMLUBxMGHEZyZvgo


eval $(dircolors -b $HOME/.dircolors)
