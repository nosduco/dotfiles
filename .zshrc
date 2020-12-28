# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh/
source ~/.bashrc

ZSH_THEME="refined"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(kubectl gitfast vi-mode dirhistory docker pip sudo yarn wd virtualenv)

# oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Theme Changes
repo_information() {
    echo "%F{yellow}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}
