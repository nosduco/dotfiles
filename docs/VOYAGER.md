# Voyager (System76 Pangolin pang15) power tuning

System76 builds these for Linux. Treat them like it. This doc is the per-host
power & sleep tuning applied by `./install` when the hostname is `voyager`.

## Hardware

- AMD Ryzen 9 8945HS (Zen 4 / Hawk Point), 8c/16t
- Radeon 780M iGPU (no dGPU)
- BOE NE160QDM-NY2 — 2560×1600 eDP, native 120 Hz
- Kingston KC3000 1 TB NVMe
- MediaTek MT7922 Wi-Fi/BT
- LUKS-encrypted root + swap — passwordless boot via TPM2 + Secure Boot
  (see [VOYAGER-secureboot-tpm2.md](VOYAGER-secureboot-tpm2.md))
- BIOS AHP938 (AMI UEFI 2.80, Microsoft Pluton TPM)

## What gets installed

Linked via dotbot on hostname=voyager. Idempotent — re-run `./install` any time.

| File | What it does |
|--|--|
| `/usr/local/bin/voyager-power` | Root-side: PPD profile, CPU boost, GPU performance level, NVMe PM. |
| `/etc/udev/rules.d/99-voyager-power.rules` | Fires `voyager-power` on AC/battery transition. |
| `/etc/udev/rules.d/81-voyager-nvme.rules` | NVMe runtime PM=auto at hotplug. |
| `/etc/systemd/system/voyager-power-state.service` | Runs `voyager-power` once at boot. |
| `/etc/systemd/logind.conf.d/voyager-lid.conf` | Lid close → suspend-then-hibernate on battery, suspend on AC. |
| `/etc/systemd/sleep.conf.d/voyager-hibernate.conf` | `HibernateDelaySec=2h`. |
| `/etc/modprobe.d/voyager-audio.conf` | snd_hda_intel power_save=1. |
| `/etc/system76-scheduler/config.kdl` | Drops `execsnoop` (parse-error spam on kernel 7.x). |
| `/etc/kernel/cmdline` (modified) | Adds `amdgpu.abmlevel=1` (Adaptive Backlight Mgmt, ~1-2 W). Original backed up at `cmdline.bak`. |
| `/etc/tmpfiles.d/voyager-aspm.conf` | Writes `powersave` to PCIe ASPM policy at boot (~0.3-0.7 W). |

## Why these particular knobs

**On battery:**
- `power-profiles-daemon` → `power-saver` profile (EPP=`power`).
- CPU boost → `0` (caps at base ~4.0 GHz; saves ~25–35 W under sustained load like `pacman -Syu`).
- GPU `power_dpm_force_performance_level=low` — pins MCLK to 1000 MHz and SCLK to 800 MHz. Measured **~7 W amdgpu PPT savings** (PPT 19 W → 12 W) and ~16 W battery_now delta on this hardware. No compositor stutter at 2560×1600@120 Hz with Hyprland blur.
- NVMe runtime PM = `auto` — KC3000 is known for high SSD idle without it.

**On AC:**
- PPD `balanced`, boost on, GPU `auto`. Full firepower.

**Always:**
- Audio codec autosuspends.
- system76-scheduler runs without execsnoop (kernel-7 BPF format mismatch was spamming journald and waking kcryptd).
- AMD Adaptive Backlight Management (`amdgpu.abmlevel=1`) — driver dynamically lowers backlight on dark content while compensating with contrast.
- PCIe ASPM `powersave` policy — devices enter L1/L1.2 substates aggressively.

## What's deliberately NOT installed

- `tlp` / `auto-cpufreq` — would conflict with `power-profiles-daemon`. PPD ≥ 0.30 has native `amd_pstate-epp` support.
- `system76-power.service` — PPD covers the same ground.
- Hyprland blur/animation toggles — kept on always per preference.
- Refresh-rate switching (120 ↔ 60 Hz on battery) — preferred high-refresh on battery; the alternative cost is acceptable given `level=low` already nukes the MCLK problem.

## Why not custom EDID (Phase 6 was abandoned)

We initially built a patched EDID with extended vblank (200 lines vs stock 96) on the theory that AMDGPU couldn't switch MCLK during the stock 471 µs vblank. Turns out **on AMD APUs that whole concept doesn't apply**: the iGPU shares system DDR5 with the CPU, so the SMU sets MCLK at mode-set time based on bandwidth needs and doesn't switch per-frame like a discrete dGPU. Vblank duration was a red herring on this hardware.

The real lever — `power_dpm_force_performance_level=low` — bypasses the question entirely. The custom EDID work was reverted; see commit history if you want the patcher back.

## Tunable knob

Top of `scripts/voyager-power.sh`:
- `BATTERY_GPU_LEVEL="low"` — pins MCLK + SCLK to lowest DPM on battery. Set to `"auto"` if you ever see compositor stutter under heavy GPU workload.

## Passwordless boot (done)

TPM2 LUKS auto-unlock under enforced Secure Boot is live — cold boot and
hibernate-resume are both passwordless. This is a **manual one-time bootstrap**,
deliberately not automated. Full runbook + recovery:
**[VOYAGER-secureboot-tpm2.md](VOYAGER-secureboot-tpm2.md)**.

## Verifying state

```fish
powerprofilesctl get                                   # balanced on AC, power-saver on battery
cat /sys/devices/system/cpu/cpufreq/boost              # 1 on AC, 0 on battery
cat /sys/class/drm/card1/device/power_dpm_force_performance_level    # auto on AC, low on battery
awk '/\*/{print $2}' /sys/class/drm/card1/device/pp_dpm_mclk         # 1000Mhz on battery
cat /sys/class/nvme/nvme0/device/power/control         # auto
journalctl -t voyager-power -n 5 --no-pager
```

## Reverting

```fish
sudo rm /usr/local/bin/voyager-power
sudo rm /etc/udev/rules.d/{99-voyager-power.rules,81-voyager-nvme.rules}
sudo rm /etc/systemd/system/voyager-power-state.service
sudo rm /etc/systemd/logind.conf.d/voyager-lid.conf
sudo rm /etc/systemd/sleep.conf.d/voyager-hibernate.conf
sudo rm /etc/modprobe.d/voyager-audio.conf
sudo rm /etc/tmpfiles.d/voyager-aspm.conf
# Strip ABM token from cmdline:
sudo sed -i 's| amdgpu.abmlevel=1||' /etc/kernel/cmdline
sudo reinstall-kernels
# Restore packaged system76-scheduler config:
sudo pacman -S system76-scheduler --overwrite '/etc/system76-scheduler/config.kdl'
sudo udevadm control --reload-rules
sudo systemctl daemon-reload
sudo systemctl kill -s HUP systemd-logind
sudo systemctl disable voyager-power-state.service
```
