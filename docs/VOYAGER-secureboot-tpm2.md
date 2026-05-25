# Voyager — Secure Boot + UKI + TPM2 LUKS auto-unlock

**Zero-input boot on a fully-encrypted laptop.** This machine boots straight to
the desktop — no LUKS passphrase, no PIN — while still being protected by
LUKS2 full-disk encryption. The disk key is sealed in the TPM and released
*only* when the firmware confirms it booted our own Secure-Boot-signed kernel.
Cold boot and resume-from-hibernate are both passwordless.

> [!IMPORTANT]
> **This is a manual, one-time bootstrap. It is deliberately NOT automated into
> dotbot / `./install`.** It touches firmware (BIOS) settings that can't be
> scripted, it handles secrets (recovery keys), and a half-applied run under
> enforced Secure Boot can leave you at a non-booting machine. Do it by hand,
> understand each step, keep the recovery key. The day-to-day power tuning in
> [VOYAGER.md](VOYAGER.md) *is* automated; this is not.

> [!NOTE]
> **You can never lock yourself out.** Three independent ways into the disk
> exist at all times: your **passphrase** (LUKS keyslot 0), a **recovery key**
> (keyslot 1), and the **TPM** (keyslot 2). The TPM is just a convenience layer
> bolted on top — if it ever refuses to release the key, you simply get the
> passphrase prompt back, exactly like before any of this. See
> [Recovery](#recovery--what-to-do-when-it-breaks).

---

## 1. The goal and why this design (Option "D")

The problem: LUKS resume/boot prompts are friction, and a hibernate cycle on
this laptop meant typing the passphrase on every wake. The requirement was
**zero human input** on resume (and cold boot is fine to match). A PIN was
explicitly rejected — any human input defeats the point.

That leaves binding the LUKS key to the TPM. Several ways to do that; we picked
the strong one:

| Option | Mechanism | Why not / why |
|---|---|---|
| **A** | TPM2 unlock bound to PCR 0/4/8/9 (no Secure Boot) | **Rejected.** Those PCRs measure the firmware, bootloader, kernel and initrd *contents*. Every kernel or bootloader update changes them → the TPM stops unsealing → you'd re-enroll after every `-Syu`. And without Secure Boot the initrd that performs the unlock is itself unsigned — an evil-maid could swap it. |
| **B** | TPM2 bound to PCR 7 *without* Secure Boot | Pointless: PCR 7 reflects Secure Boot state. With SB off it measures "SB disabled" and offers no real protection. |
| **D** | **Secure Boot (custom keys) + signed UKI + TPM2 bound to PCR 7** | **Chosen.** PCR 7 measures the *Secure Boot policy* (which keys are enrolled, that SB is on), **not** the kernel bytes. So it's stable across kernel/initrd/bootloader updates — no re-enrolling on `-Syu`. And it's meaningful: the TPM releases the key only when SB is enabled with *our* keys, and SB guarantees only our-signed image ran. The kernel + initrd + cmdline are bundled into one signed, measured blob (the UKI), so the unlocking initrd can't be tampered with. |

The trade-off of D is the up-front complexity in this document. The payoff is a
setup that survives `pacman -Syu` untouched (verified — see
[§7](#7-how-it-survives-pacman--syu)).

### Threat model in one line

This protects against **a stolen/lost laptop** and **offline disk tampering**:
the disk is useless pulled out of the machine, and if anyone modifies the boot
chain, Secure Boot refuses to run it and/or PCR 7 changes so the TPM won't
release the key — you fall back to the passphrase. It does **not** protect
against a running, unlocked machine, nor against someone who knows your login
password while it's booted. (TPM auto-unlock means disk security now leans on
your *user login* + lockscreen, since the disk opens itself.)

---

## 2. System this assumes

- **Hardware:** System76 Pangolin pang15 — Ryzen 9 8945HS, Radeon 780M.
- **Firmware:** AMI UEFI 2.80 (American Megatrends 5.29), with user-managed
  Secure Boot keys available in the BIOS (Setup Mode, custom key enrollment).
- **TPM:** Microsoft Pluton (`tpm_crb`, ACPI `MSFT0101:00`). `bootctl status`
  reports `TPM2 Support: yes`.
- **OS:** EndeavourOS (Arch). **dracut** (not mkinitcpio), **systemd-boot**,
  `kernel-install-for-dracut`.
- **Machine ID:** `d5e2fe2f9370414ba2dd0f2da91d3990` (appears in UKI filenames).
- **Disk layout (LUKS2):**

  | Mount | Device | LUKS UUID | crypttab name |
  |---|---|---|---|
  | `/` (root) | `/dev/nvme0n1p2` | `6a95e449-80d6-4d7f-8d5d-83cff8b69aea` | `luks-6a95e449-…` |
  | swap (resume) | `/dev/nvme0n1p3` | `e4233cac-3900-4871-9ba6-2eb000c6434a` | `luks-e4233cac-…` |

  Swap is encrypted and is the hibernate resume device — it **must** auto-unlock
  too, or resume-from-hibernate would prompt.

- **LUKS keyslots after this setup (both volumes):**

  | Keyslot | Token | What it is |
  |---|---|---|
  | 0 | — | Your **passphrase** (pbkdf2). The original install key. |
  | 1 | `systemd-recovery` | **Recovery key** — high-entropy string, saved as a QR code offline. |
  | 2 | `systemd-tpm2` | **TPM2**, bound to PCR 7. The automatic one. |

---

## 3. How it fits together

```
  ┌─────────────┐   verifies signature against    ┌──────────────────┐
  │  UEFI / SB   │ ──────  enrolled db key  ─────► │  systemd-boot      │
  │ (our keys)   │                                 │ (signed)           │
  └─────────────┘                                  └─────────┬────────┘
        │ measures SB policy into                            │ loads
        │ PCR 7                                              ▼
        │                                       ┌──────────────────────┐
        │                                       │  UKI (signed)          │
        │                                       │  kernel + initrd +     │
        │                                       │  cmdline in one blob   │
        │                                       └──────────┬───────────┘
        ▼                                                  │ initrd runs
  ┌─────────────────┐   "PCR 7 matches the value I         │ systemd-cryptsetup
  │      TPM2       │    was sealed against?" → yes         ▼
  │  (keyslot 2     │ ───────────────────────────►  unseals LUKS key,
  │   sealed to     │                               opens root + swap,
  │   PCR 7)        │                               no prompt → desktop
  └─────────────────┘
```

The chain of trust: **firmware trusts our db key → only our-signed
systemd-boot + UKI can run → running them produces a specific PCR 7 value →
the TPM only releases the LUKS key for that exact PCR 7 value.** Break any link
(disable SB, swap in an unsigned kernel, change the enrolled keys) and PCR 7
changes → the TPM stays sealed → you get the passphrase prompt. Nothing is
lost, you just type the passphrase.

**Two pacman hooks keep this alive across updates** (see [§7](#7-how-it-survives-pacman--syu)):
`dracut-ukify` rebuilds + signs the UKI on kernel updates; `sbctl` re-signs all
ESP binaries on relevant package changes.

---

## 4. Packages

```fish
# Repo
sudo pacman -S sbctl sbsigntools tpm2-tss tpm2-tools
# AUR (paru/yay)
paru -S dracut-ukify
```

| Package | Role |
|---|---|
| `sbctl` | Secure Boot key manager — creates custom PK/KEK/db, enrolls them into firmware, signs EFI binaries, and ships a **pacman hook** that re-signs on updates. |
| `sbsigntools` | `sbsign` / `sbverify` — the actual signing binaries dracut-ukify shells out to. |
| `dracut-ukify` (AUR) | Builds the **Unified Kernel Image** (kernel+initrd+cmdline → one PE/EFI binary), signs it, and sets it as the default boot entry. Has its **own pacman hooks** so kernel updates regenerate + re-sign the UKI automatically. |
| `tpm2-tss` | TPM2 software stack; provides the dracut `tpm2-tss` module that puts TPM support into the initrd so it can unseal at boot. |
| `tpm2-tools` | Provides the `tpm2` binary. **Required** — the dracut `tpm2-tss` module's `check()` refuses to install without it (see [gotcha #3](#83-module-tpm2-tss-cannot-be-installed)). |

---

## 5. The bootstrap procedure

> Run each phase in order. Commands needing root are shown with `sudo`. **Do
> not enable Secure Boot until the boot chain is signed** (phase 4–5) or the
> machine won't boot.

### Phase 0 — Confirm the prerequisites

```fish
# dracut, not mkinitcpio:
ls /etc/dracut.conf.d/            # exists
# TPM present:
ls /dev/tpm* /dev/tpmrm*          # /dev/tpm0, /dev/tpmrm0
# systemd-boot is the loader:
bootctl status                    # "Current Boot Loader: systemd-boot"
```

If there's a leftover dracut config that *disables* the TPM, remove it — the
initrd needs the TPM drivers:

```fish
# This file existed on voyager and omitted tpm_crb; it must go.
sudo rm -f /etc/dracut.conf.d/disable-tpm.config
```

### Phase 1 — Generate Secure Boot keys

```fish
sudo sbctl create-keys
```

Creates PK / KEK / db key+cert under `/var/lib/sbctl/keys/`. These are *your*
keys; the db key (`/var/lib/sbctl/keys/db/db.{key,pem}`) is what signs the
bootloader and UKI. **Back up `/var/lib/sbctl/keys/` somewhere safe** — losing
it means you can't sign future binaries (recover by re-running the whole key
bootstrap).

### Phase 2 — Make dracut-ukify build a *signed* UKI and keep it default

Edit `/etc/dracut-ukify.conf`, append at the bottom (see
[§6](#6-config-file-reference) for exact lines):

```ini
ukify_global_args+=(--secureboot-private-key /var/lib/sbctl/keys/db/db.key --secureboot-certificate /var/lib/sbctl/keys/db/db.pem)
default_kernel_package='linux'
```

The first line makes every UKI build sign itself with the db key. The second
makes the new UKI the default boot entry after each kernel upgrade
(equivalent to `bootctl set-default` on every update).

### Phase 3 — Put TPM support into the initrd

Create `/etc/dracut.conf.d/voyager-tpm2.conf`:

```ini
add_dracutmodules+=" tpm2-tss "
```

This applies to **both** the UKI (built by dracut-ukify) and the BLS initrd
(built by kernel-install), because both read `/etc/dracut.conf.d/`. Without it
the initrd has no TPM stack and can't unseal.

### Phase 4 — Build the signed UKI

```fish
sudo dracut-ukify -g linux
```

Watch for the signing line in the output:

```
+ sbsign --key /var/lib/sbctl/keys/db/db.key --cert /var/lib/sbctl/keys/db/db.pem … --output /efi/EFI/Linux/linux-<ver>-<machine-id>-<date>.efi
Wrote signed /efi/EFI/Linux/linux-…efi
-> Mark linux image linux (<ver>) as default
```

### Phase 5 — Sign the bootloader

```fish
sudo sbctl sign -s /efi/EFI/systemd/systemd-bootx64.efi
sudo sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI
sudo sbctl verify          # everything in the boot path should be ✓ signed
```

`-s` adds the file to sbctl's persistent sign-list, so the pacman hook
re-signs it automatically on future updates. (The four
`/efi/system76-firmware-update/*` files showing `✗ not signed` is **expected
and fine** — they're not in the boot path. See [§9](#9-system76-firmware-updates).)

### Phase 6 — Put the firmware into Setup Mode

In the **BIOS** (reboot, mash <kbd>Del</kbd>/<kbd>F2</kbd>), under the Secure
Boot / key-management menu:

1. **Disable "Factory Key Provision" *first*.** ← critical, see
   [gotcha #1](#81-setup-mode-wont-stick-factory-key-provision).
2. **Reset / Clear Secure Boot keys → "Reset to Setup Mode".**
3. Save & exit.

Back in Linux, confirm:

```fish
sudo sbctl status     # Setup Mode: ✓ Enabled   Secure Boot: ✗ Disabled
```

### Phase 7 — Enroll our keys (keep Microsoft's too)

```fish
sudo sbctl enroll-keys --microsoft
```

`--microsoft` *also* enrolls Microsoft's KEK/db alongside ours. **Keep this** —
it preserves trust for option-ROM firmware (GPU/NVMe) and the occasional
vendor binary, avoiding a bricked-peripheral situation. After this:

```fish
sudo sbctl status     # Setup Mode: ✓ Disabled   Vendor Keys: microsoft
```

### Phase 8 — Enable Secure Boot

Back in the BIOS: **set Secure Boot → Enabled**, save & exit.

> At this point only our-signed binaries boot. Because we signed the bootloader
> + UKI in phases 4–5, the machine boots normally. Confirm:

```fish
sudo sbctl status     # Secure Boot: ✓ Enabled (Setup Mode ✓ Disabled)
bootctl status        # Secure Boot: enabled (user)
```

If it **doesn't** boot here: BIOS → disable Secure Boot, boot, and re-check
that `sbctl verify` is all-green before re-enabling.

### Phase 9 — Add a recovery key to each LUKS volume (do this BEFORE the TPM)

A second human-usable key, independent of passphrase and TPM. **Run for both
volumes.** It prints a recovery key string + QR code — **save it offline**
(photo the QR, write it down). It is a secret; never commit or paste it.

```fish
sudo systemd-cryptenroll --recovery-key /dev/nvme0n1p2   # root
sudo systemd-cryptenroll --recovery-key /dev/nvme0n1p3   # swap
```

### Phase 10 — Enroll the TPM, bound to PCR 7

```fish
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2   # root
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p3   # swap
```

Each should print **`New TPM2 token enrolled as key slot 2`**. **Verify the
token actually landed** — the first attempt on voyager silently did *not*
create it (see [gotcha #4](#84-tpm2-token-didnt-take-on-the-first-try)):

```fish
sudo cryptsetup luksDump /dev/nvme0n1p2 | grep -A4 -i tpm2
# expect a "systemd-tpm2" token with Keyslot 2 and "tpm2-pcrs: 7"
```

### Phase 11 — Tell crypttab to use the TPM

Add `,tpm2-device=auto` to the options of **both** lines in `/etc/crypttab`:

```fish
# both lines should end:  none luks,tpm2-device=auto
sudo sed -i 's/ luks$/ luks,tpm2-device=auto/' /etc/crypttab
```

This is what makes the initrd actually *try* the TPM at boot (the enrolled
token is necessary but the crypttab option is what triggers the unseal attempt;
without it you'd still be prompted).

### Phase 12 — Rebuild the initrd/UKI and reboot

```fish
sudo dracut-ukify -g linux     # bake the new crypttab + tpm2 module into the UKI
# (or, most foolproof, reinstall the kernel to fire every hook:)
# sudo pacman -S linux
sudo reboot
```

**Expected: boots straight to the login screen, no passphrase.** If it still
prompts, the passphrase still works — log in and check
[Recovery](#recovery--what-to-do-when-it-breaks) / re-verify the token (gotcha #4).

### Phase 13 — (optional) Instant boot, no menu

The 5-second systemd-boot menu is controlled by an EFI variable that overrides
`loader.conf`. To go straight to boot:

```fish
sudo bootctl set-timeout 0
```

You can still force the menu by **holding <kbd>Space</kbd>** during boot (to
reach firmware setup or the BLS fallback entry).

---

## 6. Config file reference

These live on the system and are **not** tracked by dotbot. Recreate them by
hand per the steps above. Exact contents on voyager:

**`/etc/dracut-ukify.conf`** — appended after the stock comments:
```ini
ukify_global_args+=(--secureboot-private-key /var/lib/sbctl/keys/db/db.key --secureboot-certificate /var/lib/sbctl/keys/db/db.pem)
default_kernel_package='linux'
```

**`/etc/dracut.conf.d/voyager-tpm2.conf`** (whole file):
```ini
add_dracutmodules+=" tpm2-tss "
```

**`/etc/crypttab`** — both lines carry `tpm2-device=auto`:
```
luks-6a95e449-80d6-4d7f-8d5d-83cff8b69aea UUID=6a95e449-80d6-4d7f-8d5d-83cff8b69aea none luks,tpm2-device=auto
luks-e4233cac-3900-4871-9ba6-2eb000c6434a UUID=e4233cac-3900-4871-9ba6-2eb000c6434a none luks,tpm2-device=auto
```

**Removed:** `/etc/dracut.conf.d/disable-tpm.config` (was omitting `tpm_crb`).

**Key material:** `/var/lib/sbctl/keys/` (PK, KEK, db). The signing key is
`db/db.key` + `db/db.pem`.

**Not modified:** `/etc/kernel/install.conf` — we did **not** set `layout=uki`.
The UKI is built by dracut-ukify's own hooks; kernel-install still produces the
(now inert under SB, but signed) BLS entry as a fallback.

---

## 7. How it survives `pacman -Syu`

This was the whole point of choosing Option D, and it's **verified** — a real
kernel jump `7.0.3 → 7.0.10` flowed through with zero intervention.

**What happens on a kernel update:**

1. Pre-transaction: old UKI removed from the ESP.
2. `dracut-ukify` post-transaction hook: builds the new initrd, bundles the
   UKI, **signs it** with `db.key`, and **marks it default**:
   ```
   + sbsign --key /var/lib/sbctl/keys/db/db.key … Wrote signed linux-7.0.10-…efi
   -> Mark linux image linux (7.0.10-arch1-1) as default
   ```
3. `kernel-install` writes the BLS kernel copy; `sbctl` signs it.
4. `sbctl` hook (`(8/8) Signing EFI binaries`) ensures the bootloader binaries
   stay signed.
5. **PCR 7 is unchanged** — a kernel swap doesn't alter the Secure Boot policy —
   so the TPM still unseals. **No re-enrollment needed.**

**systemd / bootloader updates** are also safe: when `systemd` updated to
`260.1-2`, the bootloader was redeployed to the ESP **and re-signed** by the
sbctl hook in the same transaction. Confirmed via `sbctl verify` (✓
`systemd-bootx64.efi`) and `bootctl status` (deployed version == package
version). `systemd-boot-update.service` is **disabled**, so no surprise
unsigned-bootloader deploy happens at boot.

**The one caveat — kernel headers must move in lockstep.** A *full* `eos-update
--paru` (or `pacman -Syu`) upgrades `linux` and `linux-headers` together, so the
`system76-dkms-git` module rebuilds for the new kernel. If you ever upgrade
`linux` **alone** (`pacman -S linux`), headers stay stale and you'll see:
```
(3/8) Install DKMS modules
==> ERROR: Missing <ver> kernel headers for module system76/1.0.22.
```
This is **not** a Secure Boot problem — the UKI still builds + signs fine. Fix
by matching the headers, which rebuilds the module:
```fish
sudo pacman -S linux-headers          # → dkms install … system76/1.0.22 -k <ver>
# if it still doesn't rebuild:
sudo dkms autoinstall -k <ver>
```

**Use `eos-update --paru`** as the daily updater: it runs the same pacman
transaction (all hooks fire identically) **and** updates the AUR packages this
setup depends on — `dracut-ukify` and `system76-dkms-git`.

**What to glance at after a big update** (only if you want reassurance):
```fish
sudo sbctl verify     # boot path all ✓
```

---

## 8. Gotchas we actually hit

### 8.1 Setup Mode won't stick — "Factory Key Provision"

"Reset to Setup Mode" appeared to work but didn't persist: on the next boot the
firmware was back in User Mode with factory keys. Cause: **Factory Key
Provision was Enabled**, so the firmware re-provisions the factory keys on every
boot. **Fix: disable Factory Key Provision *first*, then Reset to Setup Mode.**

### 8.2 Use `--microsoft` when enrolling keys

`sbctl enroll-keys` without `--microsoft` enrolls *only* your keys, dropping
Microsoft's KEK/db. That can break option-ROM firmware (GPU/NVMe init) and any
Microsoft-signed binary you might need (e.g. a vendor recovery tool). We used
`--microsoft`; `sbctl status` correctly reports `Vendor Keys: microsoft`.

### 8.3 "Module 'tpm2-tss' cannot be installed"

The dracut build failed with this. The `tpm2-tss` dracut module's `check()`
requires the **`tpm2` binary**, which lives in `tpm2-tools` (not `tpm2-tss`).
**Fix:** `paru -S tpm2-tools`, then rebuild.

### 8.4 TPM2 token didn't take on the first try

After the first enroll round, the boot still prompted for the passphrase.
`luksDump` showed only the `systemd-recovery` tokens — **no `systemd-tpm2`
token**. The `systemd-cryptenroll --tpm2` step had silently not created the
token. **Fix:** re-run the exact `systemd-cryptenroll --tpm2-device=auto
--tpm2-pcrs=7` on both volumes; it then reported `New TPM2 token enrolled as
key slot 2`. **Always verify with `luksDump` (phase 10) before rebooting.**

### 8.5 The 5-second menu persists despite `loader.conf` timeout 0

`loader.conf` said `timeout 0` yet the menu showed for 5s. `bootctl
set-timeout N` writes a **`LoaderConfigTimeout` EFI variable** that *overrides*
the file. We'd set it to 5 earlier. **Fix:** `sudo bootctl set-timeout 0`
(writes the EFI var to 0).

### 8.6 A leftover `disable-tpm.config` blocked the TPM

`/etc/dracut.conf.d/disable-tpm.config` was omitting the `tpm_crb` driver, so
the initrd couldn't talk to the Pluton TPM. **Fix:** delete it (phase 0).

---

## 9. System76 firmware updates

`sbctl verify` flags four files as **not signed**:
```
✗ /efi/system76-firmware-update/boot.efi
✗ /efi/system76-firmware-update/firmware/afuefi.efi
✗ /efi/system76-firmware-update/firmware/ifu.efi
✗ /efi/system76-firmware-update/res/shell.efi
```
This is **normal**. They're System76's firmware-flashing payload (AMI firmware
updater + UEFI shell), staged in the ESP when you schedule a BIOS/EC update.
They are **not in the normal boot path**, so they don't affect boot or
auto-unlock at all.

**But when you actually flash System76 firmware:**

1. Enforced Secure Boot will **block** those unsigned binaries — so you must
   **temporarily disable Secure Boot in the BIOS** to let the updater run.
2. A firmware update can **reset your custom Secure Boot keys** (back to factory
   / Setup Mode) and **changes PCR 7**. If that happens:
   - The TPM will stop unsealing → you get the **passphrase prompt** (no
     lockout — that's the fallback working).
   - **Re-bootstrap** afterward: re-enroll keys (phases 6–8) and re-enroll the
     TPM token (wipe + re-add, see below).
3. Your **passphrase and recovery key always work** throughout — firmware
   updates can't touch keyslots 0 and 1.

Plan a firmware update as "expect to redo the Secure Boot + TPM enrollment
after." It's a ~15-minute repeat of phases 6–10, not a disaster.

---

## 10. Verifying it's healthy

```fish
# Secure Boot on, our keys, not in setup mode:
sudo sbctl status
# Whole boot path signed:
sudo sbctl verify
# Firmware view + TPM/measured-UKI:
bootctl status          # Secure Boot: enabled (user); TPM2 Support: yes; Measured UKI: yes
# The TPM token exists on both volumes:
sudo cryptsetup luksDump /dev/nvme0n1p2 | grep -i -A4 tpm2
sudo cryptsetup luksDump /dev/nvme0n1p3 | grep -i -A4 tpm2
# What unlocked the disk this boot:
sudo journalctl -b | grep -i -E 'tpm2|cryptsetup|unsealed'
```

Healthy = SB enabled/user keys, all-green verify (minus the firmware-update
files), a `systemd-tpm2` token on both volumes, and no passphrase prompt.

---

## Recovery — what to do when it breaks

**The disk is never lost.** Pick the row that matches your situation:

| Symptom | What's happening | What to do |
|---|---|---|
| Boot prompts for passphrase (used to be silent) | TPM won't unseal — PCR 7 changed (SB toggled, keys re-provisioned, firmware update) | **Type your passphrase** (keyslot 0). Once logged in: re-enroll the TPM (below). |
| Forgot passphrase | — | **Type the recovery key** (keyslot 1) at the prompt — the QR you saved. |
| Machine won't boot at all after enabling SB | An unsigned binary in the path | BIOS → **disable Secure Boot** → boot → `sudo sbctl verify`, fix the unsigned binary, re-enable SB. |
| Secure Boot totally wedged | Bad/partial key state | BIOS → **Restore Factory Keys** (and/or disable SB) → boot → re-bootstrap from phase 6. |

**Re-enroll the TPM** (after a PCR 7 change — wipe the stale token first):
```fish
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
# repeat for /dev/nvme0n1p3
```

**Fully unwind (back to passphrase-only):**
```fish
# remove TPM tokens
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3
# drop tpm2-device=auto from /etc/crypttab (both lines)
# BIOS: disable Secure Boot (or Restore Factory Keys)
sudo dracut-ukify -g linux       # rebuild without tpm2
```

> Keep the recovery key offline and safe. With the db signing key
> (`/var/lib/sbctl/keys/`) backed up, even a wiped firmware key store is a
> phase 6–8 redo, not a reinstall.

---

## Appendix — quick inventory

| Thing | Location / value |
|---|---|
| SB keys | `/var/lib/sbctl/keys/` (PK/KEK/db); signer = `db/db.{key,pem}` |
| UKI | `/efi/EFI/Linux/linux-<ver>-d5e2fe2f9370414ba2dd0f2da91d3990-<date>.efi` |
| Bootloader | `/efi/EFI/systemd/systemd-bootx64.efi`, `/efi/EFI/BOOT/BOOTX64.EFI` |
| dracut-ukify signing | `/etc/dracut-ukify.conf` (db key args + `default_kernel_package='linux'`) |
| initrd TPM module | `/etc/dracut.conf.d/voyager-tpm2.conf` (`tpm2-tss`) |
| crypttab | both lines `… none luks,tpm2-device=auto` |
| PCR bound | **7** (Secure Boot policy) |
| LUKS keyslots | 0 = passphrase, 1 = recovery key, 2 = TPM2 |
| Daily updater | `eos-update --paru` |
| Related | power/sleep tuning → [VOYAGER.md](VOYAGER.md) |
