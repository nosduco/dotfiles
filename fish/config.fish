# Disable greeting
set fish_greeting

if not status is-interactive
  # Run nothing if not running interactively
  return
end

# Enable VIM keybindings
fish_vi_key_bindings

# Zellij
# eval (zellij setup --generate-auto-start fish | string collect)

# Directory Colors
# eval (dircolors -c $HOME/.dircolors)

# Root .env variables
function posix-source
	for i in (cat $argv)
		set arr (echo $i |tr = \n)
  		set -gx $arr[1] $arr[2]
	end
end
posix-source ~/.env

# Editor
set EDITOR vim

# Neovim Terminal Specifics
if set -q nvim
  alias vim='nvr'
end

# Rust Path
fish_add_path $HOME/.cargo/bin

# Go Path
fish_add_path $HOME/go/bin

# Node Path
fish_add_path $(pnpm global bin)

# Pipx Path
fish_add_path $HOME/.local/bin

# Android Path
set ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools

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
alias cat='bat'

# Override rm for trash
alias rm='trash'

# Override ls for lsd
alias ls='lsd --date=+"%a %b %d %I:%M:%S %p %Y"'

# Prefer docker compose over docker-compose
alias docker-compose='docker compose'

# AWS helper aliases
alias aws-use='set AWS_PROFILE='

# Tmuxinator shorthand
alias mux='tmuxinator'

# Initialize Starship prompt
starship init fish | source

# Import .env variables
for i in (cat ~/.dotfiles/.env)
  set arr (echo $i |tr = \n)
    set -gx $arr[1] $arr[2]
end

# Zoxide (cd alternative)
zoxide init fish | source
alias cd="z"
alias cdi="zi"

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# pnpm
set -gx PNPM_HOME "/home/tony/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
