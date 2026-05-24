#!/bin/bash
# voyager-cmdline-tweaks.sh — idempotently adds AMD-laptop power tokens to
# /etc/kernel/cmdline and re-runs reinstall-kernels.
#
# Tokens managed:
#   amdgpu.abmlevel=1   AMD Adaptive Backlight Management. Driver
#                       dynamically lowers the panel backlight on dark
#                       content while compensating with contrast. Levels
#                       1-4 (1=mildest); 0 disables. Saves ~1-2 W on a
#                       16" 2.5K eDP panel like ours. Most users don't
#                       notice the contrast shift on dark scenes.
#   pcie_aspm=powersave PCIe Active State Power Management policy. Lets
#                       PCIe devices enter L1/L1.2 substates aggressively.
#                       Standard laptop tuning (TLP enables it by
#                       default). ~0.3-0.7 W savings. Tiny risk of corner
#                       -case device hiccups; trivial revert.
#
# Re-run any time. Initramfs/UKI rebuild only happens if cmdline changed.
# REBOOT required to activate. To revert a token, remove from TOKENS array
# and add to REMOVE_TOKENS, re-run.

set -euo pipefail

CMDLINE=/etc/kernel/cmdline
TOKENS=(
    "amdgpu.abmlevel=1"
)
# Tokens to strip if present:
#   pcie_aspm=powersave : earlier (wrong) attempt — the `pcie_aspm=` kernel
#     param only accepts off/force; ASPM policy is set via
#     /etc/tmpfiles.d/voyager-aspm.conf instead.
#   amdgpu.dcfeaturemask=0xa : tried enabling PSR (bit 3). BOE NE160QDM-NY2
#     reports "Sink support: no" — panel doesn't support PSR. Token is
#     harmless but pointless on this panel.
REMOVE_TOKENS=(
    "pcie_aspm=powersave"
    "amdgpu.dcfeaturemask=0xa"
)

needs_rebuild=0

# Backup once on first run
if [ ! -f "$CMDLINE.bak" ]; then
    sudo cp -a "$CMDLINE" "$CMDLINE.bak"
fi

for tok in "${TOKENS[@]}"; do
    if ! grep -qF -- "$tok" "$CMDLINE"; then
        echo "==> Adding '$tok' to $CMDLINE"
        sudo sed -i "s| *\$| $tok|" "$CMDLINE"
        needs_rebuild=1
    fi
done

for tok in "${REMOVE_TOKENS[@]}"; do
    if grep -qF -- "$tok" "$CMDLINE"; then
        echo "==> Removing '$tok' from $CMDLINE"
        sudo sed -i "s| *$tok||" "$CMDLINE"
        needs_rebuild=1
    fi
done

if [ "$needs_rebuild" = "1" ]; then
    echo "==> Updated cmdline:"
    cat "$CMDLINE"
    echo
    echo "==> Re-running kernel-install (sudo reinstall-kernels)..."
    if command -v reinstall-kernels >/dev/null; then
        sudo reinstall-kernels
    else
        for kver in /usr/lib/modules/*/; do
            kver=$(basename "$kver")
            [ -f "/usr/lib/modules/$kver/vmlinuz" ] && \
                sudo kernel-install add "$kver" "/usr/lib/modules/$kver/vmlinuz"
        done
    fi
    echo
    echo "==> REBOOT to activate. After boot, verify with:"
    echo "      cat /proc/cmdline | tr ' ' '\\n' | grep -E 'abm|aspm'"
else
    echo "==> Cmdline already current; nothing to do."
fi
