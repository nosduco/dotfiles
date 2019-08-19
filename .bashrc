# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:"/opt/android-sdk/platform-tools:$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.config/composer/vendor/bin"
export ANDROID_SDK_ROOT="/opt/android-sdk"
export ANDROID_SDK="/opt/android-sdk"

alias svim='sudo -E vim'
alias ll='ls -l' 
alias la='ls -al'
alias fucking='sudo'
alias windows='sudo grub-reboot 1 && sudo reboot'
alias aur='yay'
alias unitydebug='adb logcat -s Unity PackageManager dalvikvm DEBUG'
alias fs='nautilus . &'
alias clonehero='sudo $HOME/Games/clonehero/clonehero'
alias packer-io='packer'
alias ls='lsd'
alias androidem='/opt/android-sdk/emulator/emulator @$(/opt/android-sdk/emulator/emulator -list-avds)'
alias oc='code . && exit'

export HUNTER_ROOT=$HOME/.hunter

eval $(dircolors -b $HOME/.dircolors)

# Web Apps Ruby
eval "$(rbenv init -)"
