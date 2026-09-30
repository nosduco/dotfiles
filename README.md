# nosduco's dotfiles

A collection of sane dotfiles I share between my machines as a software engineer/manager/hobbyist. Declared with NixOS flakes + home-manager.

![Screenshot](https://github.com/nosduco/dotfiles/blob/main/screenshot.png)

## Stack

- **OS**: NixOS (flakes + home-manager)
- **WM**: Hyprland
- **Terminal**: Ghostty + tmux + fish
- **Editor**: Neovim
- **Shell Prompt**: Tide
- **Theme**: Catppuccin Mocha

## Hosts

- `nighthawk` - desktop
- `voyager` - laptop

## Layout

- `flake.nix` - inputs + host definitions
- `hosts/` - system config (`common/core`, `common/optional`, per host)
- `home/tony/` - home-manager config (`common` + per host)
- `config/` - raw configs linked in by home-manager
- `secrets/` - sops-encrypted secrets

## Installation

Boot the NixOS installer on the target and set a root password (`sudo passwd root`), then from another machine in this repo:

```bash
nix run .#install -- <host> <ip>
```

It generates and pushes `hosts/<host>/hardware-configuration.nix`, partitions with disko (`hosts/<host>/disko.nix`), copies the sops age key and installs. Secure Boot keys are generated and enrolled on first boot, so put the firmware in Setup Mode before booting the disk.

## Updates

Machines deploy the signed tip of the branch automatically via comin. Rebuild by hand with `nh os switch`.
