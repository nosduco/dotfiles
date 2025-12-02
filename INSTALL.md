# Arch Linux + Hyprland Fresh Install Guide

**For: nighthawk (Desktop) - nosduco's dotfiles**

Based on actual commands run during December 2, 2025 reinstall.

---

## Phase 1: Data Recovery from Old Encrypted Drive

```bash
# Unlock old LUKS encrypted partition
sudo cryptsetup open /dev/nvme1n1p2 old
sudo mount /dev/mapper/old /mnt

# Copy home directories
sudo cp -R /mnt/home/tony/Desktop ~/Desktop
sudo cp -R /mnt/home/tony/Downloads ~/Downloads
sudo cp -R /mnt/home/tony/Documents ~/Documents
sudo cp -R /mnt/home/tony/Pictures ~/Pictures
sudo cp -R /mnt/home/tony/Videos ~/Videos
sudo cp -R /mnt/home/tony/Music ~/Music
sudo cp -R /mnt/home/tony/Games ~/Games
sudo cp -R /mnt/home/tony/projects ~/projects
sudo cp -R /mnt/home/tony/work ~/work
sudo cp -R /mnt/home/tony/tools ~/tools
sudo cp -R /mnt/home/tony/backups ~/backups
sudo cp -R /mnt/home/tony/notes ~/notes
sudo cp -R /mnt/home/tony/Templates ~/Templates
sudo cp -R /mnt/home/tony/Public ~/Public
sudo cp -R /mnt/home/tony/tmp ~/tmp

# Fix ownership
sudo chown -R tony:tony ~
```

---

## Phase 2: AUR Helper (paru)

```bash
sudo pacman -S --needed base-devel git

cd ~/tmp/paru
git config --global --add safe.directory /home/tony/tmp/paru
git pull origin main

# Set rust stable (required for build)
rustup default stable

# Build and install
makepkg -si

# Configure (enable Color, ParallelDownloads, multilib)
sudo nvim /etc/pacman.conf
sudo nvim /etc/paru.conf
```

---

## Phase 3: Hyprland Desktop Environment

```bash
paru -S hyprland hyprcursor hyprgraphics hypridle hyprland-guiutils \
       hyprland-protocols hyprland-qt-support hyprlang hyprlock \
       hyprpaper hyprpicker hyprshot hyprtoolkit hyprutils hyprwayland-scanner

paru -S uwsm
paru -S greetd greetd-tuigreet
sudo systemctl enable greetd.service
```

---

## Phase 4: Terminal & Shell

```bash
paru -S ghostty tmux fish
paru -S starship        # prompt
paru -S zoxide          # cd replacement
paru -S lsd             # ls replacement
paru -S bat             # cat replacement
paru -S btop            # top replacement
paru -S trash-cli       # rm replacement
paru -S ripgrep         # grep replacement
paru -S virtualfish     # python venvs for fish
```

---

## Phase 5: Neovim

```bash
paru -S neovim neovim-symlinks
```

---

## Phase 6: Fonts

```bash
paru -S ttf-google-fonts-git ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common
paru -S ttf-google-sans ttf-jetbrains-mono ttf-jetbrains-mono-nerd
```

---

## Phase 7: Desktop Utilities

```bash
paru -S waybar          # status bar
paru -S dunst           # notifications
paru -S wlogout         # logout menu
paru -S walker          # launcher
paru -S elephant-all-bin # calculator for walker
paru -S cava            # audio visualizer
```

---

## Phase 8: SSH & Dotfiles

```bash
# Copy SSH keys
cp -r /mnt/home/tony/.ssh ~/.ssh

# Clone dotfiles
git clone git@github.com:nosduco/dotfiles.git ~/.dotfiles

# Run dotbot
cd ~/.dotfiles
./install
```

---

## Phase 9: Development Tools

```bash
paru -S fnm pnpm yarn
paru -S aws-cli-v2
paru -S awsvpnclient
sudo systemctl enable --now awsvpnclient.service
paru -S codespell
```

---

## Phase 10: Copy Configs from Old Drive

```bash
cp /mnt/home/tony/.env ~/.env
cp -r /mnt/home/tony/.aws ~/.aws
cp -r /mnt/home/tony/.azure ~/.azure
cp -r /mnt/home/tony/.claude ~/.claude
cp -r /mnt/home/tony/.codex ~/.codex
cp -r /mnt/home/tony/.mongodb ~/.mongodb
cp -r /mnt/home/tony/.snowflake ~/.snowflake
cp -r /mnt/home/tony/.snowsql ~/.snowsql

# Create empty .env in dotfiles (sourced by fish)
touch ~/.dotfiles/.env
```

---

## Phase 11: Applications

```bash
paru -S chromium
paru -S firefoxpwa
paru -S vesktop             # Discord
paru -S slack-desktop
paru -S spotify-launcher spicetify-cli
paru -S streamcontroller
paru -S protonvpn-app
paru -S nautilus eog        # file manager, image viewer
paru -S fastfetch
paru -S ddcutil             # monitor control
paru -S speech-dispatcher
```

### Spicetify Setup
```bash
git clone git@github.com:catppuccin/spicetify.git /tmp/spicetify
cp -r /tmp/spicetify/catppuccin ~/.config/spicetify/Themes/
spicetify backup apply
```

---

## Phase 12: Theming

```bash
paru -S nwg-look
paru -S papirus-icon-theme papirus-folders-catppuccin-git

# Set folder colors
papirus-folders -C cat-mocha-peach --theme Papirus-Dark
```

---

## Phase 13: Firefox userChrome.css (Sidebery tab hiding)

```bash
# Find from old drive
find /mnt/home/tony/.mozilla/firefox -name userChrome.css

# Copy to dotfiles
cp /mnt/home/tony/.mozilla/firefox/731u7zmr.default-release/chrome/userChrome.css ~/.dotfiles/

# Apply to new profile
cd ~/.mozilla/firefox/*.default-release
mkdir -p chrome
cp ~/.dotfiles/userChrome.css chrome/
```

Enable `toolkit.legacyUserProfileCustomizations.stylesheets` in `about:config`.

---

## Phase 14: Desktop Files (Wayland flags)

```bash
# Copy customized .desktop files with Wayland/Ozone flags
mkdir -p ~/.local/share/applications
cp /mnt/home/tony/.local/share/applications/chromium.desktop ~/.local/share/applications/
cp /mnt/home/tony/.local/share/applications/slack.desktop ~/.local/share/applications/
cp /mnt/home/tony/.local/share/applications/vesktop.desktop ~/.local/share/applications/
cp /mnt/home/tony/.local/share/applications/obsidian.desktop ~/.local/share/applications/
```

---

## Phase 15: Final Steps

```bash
# Merge fish history
cat /mnt/home/tony/.local/share/fish/fish_history >> ~/.local/share/fish/fish_history
history merge

# Restart wireplumber
systemctl --user restart wireplumber.service

# Backup LUKS header
sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 --header-backup-file ~/luks-header.img

# Unmount old drive
sudo umount /mnt
sudo cryptsetup close old
```

---

## Quick Install (Copy-Paste)

```bash
# Core desktop
paru -S hyprland hyprcursor hyprgraphics hypridle hyprland-guiutils hyprland-protocols hyprland-qt-support hyprlang hyprlock hyprpaper hyprpicker hyprshot hyprtoolkit hyprutils hyprwayland-scanner uwsm greetd greetd-tuigreet

# Terminal stack
paru -S ghostty tmux fish starship zoxide lsd bat btop trash-cli ripgrep virtualfish

# Desktop utilities
paru -S waybar dunst wlogout walker elephant-all-bin cava

# Fonts
paru -S ttf-google-fonts-git ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-google-sans ttf-jetbrains-mono ttf-jetbrains-mono-nerd

# Neovim
paru -S neovim neovim-symlinks

# Dev tools
paru -S fnm pnpm yarn aws-cli-v2 awsvpnclient codespell

# Apps
paru -S chromium firefoxpwa vesktop slack-desktop spotify-launcher spicetify-cli streamcontroller protonvpn-app nautilus eog fastfetch ddcutil speech-dispatcher

# Theming
paru -S nwg-look papirus-icon-theme papirus-folders-catppuccin-git
```

---

## Notes

- **Keyring**: gcr/Seahorse (`SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh`)
- **NVIDIA flags**: See `hypr/env.conf` and `hypr/host/nighthawk.conf`
- **greetd config**: Installed via dotbot to `/etc/greetd/config.toml`
