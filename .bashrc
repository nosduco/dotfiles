# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Mac/Linux Configurations
if [ "$(uname)" = "Darwin" ]; then
  # Editor
  export EDITOR=nvim

  # Directory Colors
  eval $(gdircolors -b $HOME/.dircolors)

  # Custom Grep
  alias grep='ggrep --color=always'

  # Open File System
  alias fs='open .'

  export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
else 
  # Editor
  export EDITOR=vim

  # Directory Colors
  #eval $(gdircolors -b $HOME/.dircolors)
  eval $(dircolors -b $HOME/.dircolors)

  # Custom Grep
  alias grep='grep --color=always'

  # Node
  source /usr/share/nvm/init-nvm.sh

  # Open File System
  alias fs='nautilus . &'
fi

# Override rm for trash
alias rm=trash

# Override ls for lsd
alias ls=lsd

# Java
export JDK_HOME="/usr/lib/jvm/java-11-openjdk"

# C - Hunter Support
export HUNTER_ROOT=$HOME/.hunter

# Ruby
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH=$PATH:$GEM_HOME/bin

# Rust
export PATH=$PATH:$HOME/.cargo/bin

# PHP
export PATH=$PATH:$HOME/.config/composer/vendor/bin

# Go
export PATH=$PATH:$HOME/go/bin

# Node
export PATH=$PATH:$(yarn global bin)

# Android Studio
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Aliases
alias svim='sudo -E nvim'
alias svi='sudo -E nvim'
alias vi='nvim'
alias ll='ls -l' 
alias lla='ls -la'
alias la='ls -a'
alias lt='ls --tree'
alias fucking='sudo'
alias aur='paru'
alias androidem='/opt/android-sdk/emulator/emulator @$(/opt/android-sdk/emulator/emulator -list-avds)'
alias unitydebug='adb logcat -s Unity PackageManager dalvikvm DEBUG'
alias windows='sudo grub-reboot 1 && sudo reboot'
alias we='curl wttr.in\?0nqF'

# Log Levels
export OPENCV_LOG_LEVEL=ERROR
