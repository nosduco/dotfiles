#!/bin/bash

# Set custom keybinds list for Terminal and Rofi
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi/']"

# Set properties for Terminal keybind
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/ command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/ binding '<Super>return'

# Set properties for Rofi keybind
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi/ name 'Rofi'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi/ command 'rofi -show combi'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi/ binding '<Alt>space'

# Set keybinds for pop-shell
gsettings set org.gnome.shell.extensions.pop-shell tile-enter "['<Super>backslash']"
gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking-global "['<Super>h']"
gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking "[]"
gsettings set org.gnome.shell.extensions.pop-shell toggle-floating "['<Super>f']"
