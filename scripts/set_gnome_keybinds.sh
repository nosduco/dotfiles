#!/bin/bash

# Set custom keybinds list for Terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/']"

# Set properties for Terminal keybind
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/ command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/ binding '<Super>return'

# Set keybinds for pop-shell
gsettings set org.gnome.shell.extensions.pop-shell tile-enter "['<Super>backslash']"
gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking-global "['<Super>h']"
gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking "[]"
gsettings set org.gnome.shell.extensions.pop-shell toggle-floating "['<Super>f']"
gsettings set org.gnome.shell.extensions.pop-shell activate-launcher "['<Alt>space']"
