# nosduco's dotfiles

A collection of sane dotfiles I share between my machines as a software engineer/manager/hobbyist.

![Screenshot](https://github.com/nosduco/dotfiles/blob/main/screenshot.png)

## Stack

- **WM**: Hyprland
- **Terminal**: Ghostty + tmux + fish
- **Editor**: Neovim (NvChad)
- **Shell Prompt**: Starship
- **Theme**: Catppuccin Mocha

## Installation

```bash
git clone git@github.com:nosduco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install
```

Uses [dotbot](https://github.com/anishathalye/dotbot) for symlink management. Host-specific configs are handled via hostname detection.

## Documentation

- [Installation Guide](docs/INSTALL.md) - Full Arch + Hyprland setup
- [Btrfs Snapshots](docs/BTRFS.md) - Snapper + Btrfs setup
