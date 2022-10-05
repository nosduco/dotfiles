# Path to your oh-my-zsh installation.
# TODO: Edit for mac
# export ZSH=~/.oh-my-zsh/
export ZSH=/usr/share/oh-my-zsh/

ZSH_THEME="refined"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# TODO: Edit for mac
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Plugins
plugins=(gitfast vi-mode dirhistory docker pip sudo yarn wd virtualenv tmux)

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

# Mac Configurations
if [ "$(uname)" = "Darwin" ]; then
  alias vim='nvim'

#  if command -v pyenv 1>/dev/null 2>&1; then
#    eval "$(pyenv init -)"
#  fi
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
