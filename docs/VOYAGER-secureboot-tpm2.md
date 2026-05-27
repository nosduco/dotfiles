# Secure Boot + UKI + TPM2 LUKS auto-unlock (voyager)

Passwordless boot on a LUKS-encrypted laptop. The disk key is sealed in the TPM
against PCR 7 (the Secure Boot policy) and released only when the machine boots
our own signed kernel. Cold boot and hibernate-resume need no passphrase.

Manual one-time bootstrap, not part of dotbot: it touches BIOS settings, handles
the recovery key, and a half-finished run under enforced Secure Boot can leave
the box unbootable. You can't lock yourself out though — the passphrase
(keyslot 0) and recovery key (keyslot 1) always work at the prompt; the TPM
(keyslot 2) is only convenience.

PCR 7 measures the Secure Boot policy, not the kernel bytes, so it stays valid
across kernel and bootloader updates. Nothing to re-enroll on `pacman -Syu`.

## Layout

- root: `/dev/nvme0n1p2`, LUKS UUID `6a95e449-80d6-4d7f-8d5d-83cff8b69aea`
- swap: `/dev/nvme0n1p3`, LUKS UUID `e4233cac-3900-4871-9ba6-2eb000c6434a` (resume device, must auto-unlock too)
- EndeavourOS, dracut, systemd-boot, machine-id `d5e2fe2f9370414ba2dd0f2da91d3990`
- Pluton TPM (`tpm_crb`), AMI firmware with user-managed Secure Boot keys

## Packages

```
sudo pacman -S sbctl sbsigntools tpm2-tss tpm2-tools
paru -S dracut-ukify
```

`tpm2-tools` is required: the dracut `tpm2-tss` module won't install without the `tpm2` binary.

## Bootstrap

Don't enable Secure Boot until the boot chain is signed (through step 5).

1. Remove any dracut config that disables the TPM:

   ```
   sudo rm -f /etc/dracut.conf.d/disable-tpm.config
   ```

2. Create keys, then back up `/var/lib/sbctl/keys`:

   ```
   sudo sbctl create-keys
   ```

3. Append to `/etc/dracut-ukify.conf` so the UKI is signed and stays default:

   ```
   ukify_global_args+=(--secureboot-private-key /var/lib/sbctl/keys/db/db.key --secureboot-certificate /var/lib/sbctl/keys/db/db.pem)
   default_kernel_package='linux'
   ```

4. Put the TPM stack in the initrd, `/etc/dracut.conf.d/voyager-tpm2.conf`:

   ```
   add_dracutmodules+=" tpm2-tss "
   ```

5. Build and sign the UKI and bootloader:

   ```
   sudo dracut-ukify -g linux
   sudo sbctl sign -s /efi/EFI/systemd/systemd-bootx64.efi
   sudo sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI
   sudo sbctl verify
   ```

   (`/efi/system76-firmware-update/*` staying unsigned is fine, it's not in the boot path.)

6. BIOS: disable Factory Key Provision first (or Setup Mode won't stick), then reset to Setup Mode. `sudo sbctl status` should then show Setup Mode enabled.

7. Enroll keys, keeping Microsoft's (or option-ROM / GPU / NVMe firmware can break):

   ```
   sudo sbctl enroll-keys --microsoft
   ```

8. BIOS: enable Secure Boot. It boots because the chain is signed. Confirm with `sudo sbctl status`.

9. Add a recovery key to both volumes. Each prints a key and QR code; save it offline, it's a secret:

   ```
   sudo systemd-cryptenroll --recovery-key /dev/nvme0n1p2
   sudo systemd-cryptenroll --recovery-key /dev/nvme0n1p3
   ```

10. Enroll the TPM against PCR 7 on both, then confirm the token landed (the first attempt sometimes silently doesn't):

    ```
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p3
    sudo cryptsetup luksDump /dev/nvme0n1p2 | grep -iA4 tpm2
    ```

11. Add `tpm2-device=auto` to both `/etc/crypttab` lines (this triggers the unseal at boot):

    ```
    sudo sed -i 's/ luks$/ luks,tpm2-device=auto/' /etc/crypttab
    ```

12. Rebuild and reboot:

    ```
    sudo dracut-ukify -g linux
    sudo reboot
    ```

Boots straight to login. Optional instant boot: `sudo bootctl set-timeout 0` (hold Space at boot to force the menu).

## Updates

`pacman -Syu` needs no intervention: the dracut-ukify hook rebuilds and signs the UKI on kernel updates, the sbctl hook keeps the bootloader signed, and PCR 7 doesn't change. Use `eos-update --paru` so the AUR deps (`dracut-ukify`, `system76-dkms-git`) update too. Upgrading `linux` without `linux-headers` makes the DKMS build fail (harmless to boot; fix with `sudo pacman -S linux-headers`).

## Gotchas

- Setup Mode reverts on reboot unless Factory Key Provision is disabled first.
- `enroll-keys` needs `--microsoft` or you lose option-ROM trust.
- The `tpm2-tss` dracut module needs `tpm2-tools` installed.
- The TPM enroll can silently no-op; always `luksDump` to confirm the `systemd-tpm2` token before rebooting.
- `bootctl set-timeout` writes an EFI variable that overrides `loader.conf`.

## Recovery

The disk is never lost: passphrase (slot 0) and recovery key (slot 1) work at the prompt regardless.

- Boots to a passphrase prompt when it used to be silent: PCR 7 changed (SB toggled, keys or firmware changed). Type the passphrase, then re-enroll the TPM:

  ```
  sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2
  sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
  # repeat for /dev/nvme0n1p3
  ```

- Won't boot after enabling Secure Boot: BIOS, disable Secure Boot, boot, `sudo sbctl verify`, fix, re-enable.
- Secure Boot wedged: BIOS, Restore Factory Keys (or leave SB off), re-bootstrap from step 6.
- Back to passphrase-only: wipe the tpm2 slots, drop `tpm2-device=auto` from crypttab, disable SB, `sudo dracut-ukify -g linux`.

## System76 firmware updates

The updater binaries under `/efi/system76-firmware-update/` are unsigned, so enforced Secure Boot blocks them; disable SB to flash. A firmware update can also reset your custom keys and change PCR 7, dropping you to the passphrase prompt. If that happens, redo steps 6-10. Passphrase and recovery key are unaffected.
