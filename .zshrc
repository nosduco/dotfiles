# zprof - Profiling zsh
zmodload zsh/zprof

# Path to your oh-my-zsh installation.
if [ "$(uname)" = "Darwin" ]; then
  # Mac Configuration
  export ZSH=~/.oh-my-zsh/

  # Plugins
  plugins=(gitfast vi-mode dirhistory docker pip zsh-nvm sudo yarn wd virtualenv tmux zsh-autosuggestions zsh-syntax-highlighting)
else
  # [Li]nux configuration
  export ZSH=/usr/share/oh-my-zsh/

  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

  # Plugins
  plugins=(gitfast vi-mode dirhistory docker pip sudo yarn wd tmux)

  # Setup GPG
  export GPG_TTY=$(tty)
fi

ZSH_THEME="refined"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_UNICODE=true
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# oh-my-zsh
source $ZSH/oh-my-zsh.sh

# bashrc
source ~/.bashrc

# env variables
set -a
source ~/.dotfiles/.env
set +a

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Theme Changes
repo_information() {
  echo "%F{yellow}${vcs_info_msg_0_%%/.} %F{red}%B(%m)%b %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Mac Configurations
if [ "$(uname)" = "Darwin" ]; then
  alias vim='nvim'
fi

# Node Configuration
eval "$(fnm env --use-on-cd)"

# Python Configuration
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Custom Functions
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
