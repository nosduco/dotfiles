#!/bin/bash
# voyager-power.sh — invoked by udev (and by voyager-power-state.service at
# boot) on every AC/battery transition. Runs as root.
#
# Sets root-owned state based on AC vs battery:
#   - power-profiles-daemon profile (balanced ↔ power-saver). PPD's profiles
#     also flip per-CPU-policy boost (1 for balanced, 0 for power-saver), so
#     we don't manage global boost — see the comment below the busctl call.
#   - amdgpu performance level (auto on AC; level=low on battery — pins
#     MCLK to 1000 MHz and SCLK to 800 MHz, ~7 W amdgpu PPT savings)
#   - NVMe runtime PM (auto, always)
#
# Knobs (top of file):
#   BATTERY_GPU_LEVEL="low"    Forces both MCLK (1000 MHz) and SCLK (800 MHz)
#                              to their lowest DPM levels on battery via
#                              `power_dpm_force_performance_level=low`.
#                              Tested smooth on 2560x1600@120 Hz Hyprland with
#                              blur on this Phoenix iGPU. Saves ~7 W GPU PPT.
#                              Set to "auto" if you experience compositor
#                              stutter under heavy GPU work.
#
#                              Why not `manual` + pp_dpm_mclk=0? On Phoenix
#                              the SMU silently ignores pp_dpm_mclk, AND
#                              entering manual mode pushes SCLK to its highest
#                              allowed level — net negative.

set -u

# ------------------- knobs -------------------
BATTERY_GPU_LEVEL="${BATTERY_GPU_LEVEL:-low}"   # low | auto
# ---------------------------------------------

ONLINE=$(cat /sys/class/power_supply/A*/online 2>/dev/null | head -1)
[ -z "$ONLINE" ] && { echo "no AC adapter found"; exit 0; }

if [ "$ONLINE" = "1" ]; then MODE=ac; else MODE=battery; fi

log() { logger -t voyager-power "$@"; }

# ---- 1. PPD profile (via direct D-Bus Properties.Set) ----
# We tested switching to system76-power as the daemon — its "battery" profile
# is less aggressive than PPD's "power-saver" (keeps per-policy boost=1 and
# EPP=balance_power instead of disabling boost + EPP=power), costing ~5 W on
# active workloads. Reverted. system76-power is only used as a one-shot at
# boot to set EC-resident battery charge thresholds (~80% cap), then stopped.
# Daily profile management stays with PPD.
#
# `powerprofilesctl set` silently no-ops from the udev-fired context. The
# busctl Properties.Set path isn't polkit-gated the same way.
if [ "$MODE" = "ac" ]; then
    PROFILE=balanced
else
    PROFILE=power-saver
fi
busctl --system call \
    net.hadess.PowerProfiles \
    /net/hadess/PowerProfiles \
    org.freedesktop.DBus.Properties Set ssv \
    net.hadess.PowerProfiles ActiveProfile s "$PROFILE" \
    >/dev/null 2>&1 || true

# ---- 3. amdgpu performance level ----
# On AC: auto (full SMU scaling).
# On battery: BATTERY_GPU_LEVEL (default "low") which pins MCLK to 1000 MHz
# and SCLK to 800 MHz. Measured saving: ~7 W amdgpu PPT, no compositor lag at
# 2560x1600@120 Hz with Hyprland blur on the 780M.
GPU_DEV=""
for d in /sys/class/drm/card*/device; do
    [ -f "$d/power_dpm_force_performance_level" ] && { GPU_DEV="$d"; break; }
done

if [ -n "$GPU_DEV" ]; then
    if [ "$MODE" = "ac" ]; then
        echo auto > "$GPU_DEV/power_dpm_force_performance_level" 2>/dev/null || true
    else
        echo "$BATTERY_GPU_LEVEL" > "$GPU_DEV/power_dpm_force_performance_level" 2>/dev/null || true
    fi
fi

# ---- 4. NVMe runtime PM (always auto; safe on Kingston KC3000) ----
for f in /sys/class/nvme/nvme*/device/power/control; do
    [ -w "$f" ] && echo auto > "$f" 2>/dev/null || true
done

# ---- 5. PCI device runtime PM: MediaTek MT7922 WiFi ----
# Kernel leaves the WiFi card at control=on so it never runtime-suspends
# when idle (~0.5-1 W cost). Our 81-voyager-pci-pm.rules udev rule didn't
# fire at boot (PCI devices don't reliably emit add uevents during enumeration),
# so writing here is the durable path.
for d in /sys/bus/pci/devices/*/; do
    vendor=$(cat "$d/vendor" 2>/dev/null)
    device=$(cat "$d/device" 2>/dev/null)
    if [ "$vendor" = "0x14c3" ] && [ "$device" = "0x7922" ]; then
        echo auto > "$d/power/control" 2>/dev/null || true
    fi
done

log "applied $MODE: PPD=$(powerprofilesctl get 2>/dev/null) policy0_boost=$(cat /sys/devices/system/cpu/cpufreq/policy0/boost 2>/dev/null) GPU=$(cat $GPU_DEV/power_dpm_force_performance_level 2>/dev/null) MCLK=$(awk '/\*/{print $2}' "$GPU_DEV/pp_dpm_mclk" 2>/dev/null | xargs)"
