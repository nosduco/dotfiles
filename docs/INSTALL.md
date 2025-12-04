# Arch Linux + Hyprland Install Guide

Assumes fresh Arch install with base packages, user created, and sudo configured.

---

## 1. AUR Helper (paru)

```bash
sudo pacman -S --needed base-devel git rustup
rustup default stable
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru && makepkg -si
```

Enable `Color`, `ParallelDownloads`, and `multilib` in `/etc/pacman.conf`.

---

## 2. Hyprland Desktop

```bash
paru -S hyprland hyprcursor hyprgraphics hypridle hyprland-protocols hyprlang \
       hyprlock hyprpaper hyprpicker hyprshot hyprutils hyprwayland-scanner \
       uwsm greetd greetd-tuigreet
```

---

## 3. Terminal Stack

```bash
paru -S ghostty tmux fish starship zoxide lsd bat btop trash-cli ripgrep virtualfish
```

---

## 4. Fonts

```bash
paru -S ttf-google-fonts-git ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common \
       ttf-google-sans ttf-jetbrains-mono ttf-jetbrains-mono-nerd \
       ttf-material-design-icons-git
```

---

## 5. Desktop Utilities

```bash
paru -S waybar dunst wlogout walker elephant-all-bin cava
```

---

## 6. Neovim

```bash
paru -S neovim neovim-symlinks
```

---

## 7. Applications

```bash
paru -S chromium firefoxpwa vesktop slack-desktop spotify-launcher spicetify-cli \
       streamcontroller protonvpn-app nautilus eog fastfetch ddcutil speech-dispatcher
```

---

## 8. Theming

```bash
paru -S nwg-look papirus-icon-theme papirus-folders-catppuccin-git catppuccin-gtk-theme-mocha
papirus-folders -C cat-mocha-peach --theme Papirus-Dark
```

---

## 9. Dotfiles

```bash
git clone git@github.com:nosduco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install
```

Dotbot handles host-specific configuration via hostname detection (see `install.conf.yaml`).

---

## 10. Post-Install

**Enable greetd:**
```bash
sudo systemctl enable greetd.service
```

**Spicetify (Spotify theming):**
```bash
git clone https://github.com/catppuccin/spicetify.git /tmp/spicetify
cp -r /tmp/spicetify/catppuccin ~/.config/spicetify/Themes/
spicetify backup apply
```

**Firefox userChrome.css (Sidebery tab hiding):**
```bash
cd ~/.mozilla/firefox/*.default-release
mkdir -p chrome
cp ~/.dotfiles/userChrome.css chrome/
```
Enable `toolkit.legacyUserProfileCustomizations.stylesheets` in `about:config`.

---

## Notes

- **Keyring**: gcr/Seahorse (`SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh`)
- **NVIDIA**: See `hypr/env.conf` for required environment variables
- **greetd config**: Installed via dotbot to `/etc/greetd/config.toml`

---

## See Also

- [BTRFS.md](BTRFS.md) - Snapper + Btrfs snapshot setup
