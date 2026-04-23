#!/usr/bin/env bash
# Symlinks kopia's user systemd units into ~/.config/systemd/user and
# enables the snapshot timer. Idempotent. Invoked from install.conf.yaml.
set -eu

SYSTEMD_SRC="$HOME/.dotfiles/systemd/user"
SYSTEMD_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

mkdir -p "$SYSTEMD_DEST"

for unit in kopia-snapshot.service kopia-snapshot.timer kopia-notify@.service; do
    ln -sf "$SYSTEMD_SRC/$unit" "$SYSTEMD_DEST/$unit"
done

# daemon-reload + enable are best-effort: they can fail when the user bus
# isn't up (e.g. running ./install in a non-graphical session). Timer gets
# picked up on next login regardless.
systemctl --user daemon-reload 2>/dev/null || true
systemctl --user enable --now kopia-snapshot.timer 2>/dev/null || true
