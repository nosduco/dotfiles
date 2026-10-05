# Host bootstrap

Install a host from another machine with one command. The target only runs the NixOS installer.

## Requirements

- The host is in `flake.nix` with `hosts/<host>/disko.nix` and a placeholder `hosts/<host>/hardware-configuration.nix` (`{ }`). The app refuses any other host.
- The host's secrets are in `secrets/secrets.yaml`: `syncthing-cert-<host>`, `syncthing-key-<host>`, `kopia-password-<host>`.
- The host's SSH key is in `keys/allowed_signers` and `keys/authorized_keys`.
- The driving machine has this repo committed and pushed, working commit signing, and the dotfiles age key at `~/.config/sops/age/dotfiles.txt` (or `AGE_KEY=<path>`).

## 1. Target: boot the installer

1. Firmware: Secure Boot off (the ISO is not signed).
2. Boot the NixOS minimal ISO from USB.
3. Network: ethernet, or `nmcli --ask device wifi connect <ssid>`.
4. `sudo passwd root`, then `ip -4 a` for the IP.

## 2. Driving machine: install

```bash
nix run .#install -- <host> <ip>
```

It asks for the installer root password, the host name to confirm the wipe, and the disk passphrase twice. It commits and pushes the generated `hardware-configuration.nix` before installing, so comin deploys the same commit on first boot. It ends by rebooting the target into firmware setup (Secure Boot hosts) or a normal reboot.

## 3. Target: Secure Boot

Hosts importing `hosts/common/optional/secureboot.nix`. Keys are generated on the machine and never leave it.

1. Firmware setup: Secure Boot enabled, then **Reset to Setup Mode** (or erase only the Platform Key). Not "Clear All Secure Boot Keys", that also drops the revocation list (dbx). Save, remove the USB, boot the disk.
2. Boot 1: disk passphrase. Keys are generated, the boot files re-signed, then it reboots itself.
3. Boot 2: systemd-boot enrolls the keys (Microsoft keys included) and reboots.
4. Boot 3: disk passphrase. `sbctl status` shows Secure Boot enabled and Setup Mode disabled. If Secure Boot shows disabled, enable it in the firmware now.

## 4. Target: TPM unlock

Only after step 3, since enrolling the keys changes PCR 7. Save both recovery keys in Bitwarden.

```bash
for p in root swap; do sudo systemd-cryptenroll --recovery-key /dev/disk/by-partlabel/disk-main-$p; done
for p in root swap; do sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/disk/by-partlabel/disk-main-$p; done
```

The next boot unlocks without the passphrase.

## Repo on the host

Home-manager clones the repo to `programs.nh.flake` (`~/.dotfiles`) on the first switch with network: the first comin deploy, or `nh os switch`. Fetch is over HTTPS, push over SSH.

## Notes vault

Home-manager seeds Obsidian LiveSync into `~/notes` once (plugin, settings from sops, `flag_fetch.md`). On the first Obsidian start, open the `notes` vault, trust its plugins, then pick "Overwrite all with remote files" and "Keep local files". Customization Sync brings the other plugins.

## Reinstall

Same steps. Keys are per install, so the firmware needs Setup Mode again.
