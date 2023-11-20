# Disable greeting
set fish_greeting

if not status is-interactive
  # Run nothing if not running interactively
  return
end

# Enable VIM keybindings
fish_vi_key_bindings

# Directory Colors
# eval (dircolors -c $HOME/.dircolors)

# Root .env variables
# TODO:

# Rust Path
fish_add_path $HOME/.cargo.bin

# Go Path
fish_add_path $HOME/go/bin

# Node Path
fish_add_path $(yarn global bin)

# Aliases
alias grep='rg --color=always'
alias fs='nautilus . &'
alias svim='sudo -E nvim'
alias ll='ls -l'
alias lla='ls -la'
alias la='ls -a'
alias lt='ls --tree'
alias pacman='paru'
alias bell='echo -e "\a"'
alias nvm='fnm'

# Override rm for trash
alias rm='trash'

# Override ls for lsd
alias ls='lsd --date=+"%a %b %d %I:%M:%S %p %Y"'

# Prefer docker compose over docker-compose
alias docker-compose='docker compose'

# AWS helper aliases
alias aws-use='set AWS_PROFILE='

# Initialize Starship prompt
starship init fish | source
