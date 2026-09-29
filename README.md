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

Boot the NixOS installer on the target, then from another machine:

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#<host> --target-host root@<ip>
```

Disks are declared with disko (`hosts/<host>/disko.nix`). Secrets need the age key at `/var/lib/sops-nix/key.txt`.

## Updates

Machines deploy the signed tip of the branch automatically via comin. Rebuild by hand with `nh os switch`.
