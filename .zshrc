# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh/

ZSH_THEME="refined"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(gitfast vi-mode dirhistory docker pip sudo yarn wd kubectl virtualenv tmux)

# oh-my-zsh
source $ZSH/oh-my-zsh.sh

# bashrc
source ~/.bashrc

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Theme Changes
repo_information() {
  echo "%F{yellow}${vcs_info_msg_0_%%/.} %F{red}%B(%m)%b %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}

