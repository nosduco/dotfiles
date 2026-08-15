#!/bin/bash
# Wire up the tuxcloud rclone mount at ~/cloud.
#
# Runs from install.conf.yaml. Idempotent: safe to re-run on every ./install.
#
# This lives in a script rather than inline in the manifest because dotbot runs
# shell commands through "$SHELL", and .tmux.conf sets default-shell to fish -
# so an inline POSIX `if ... fi` is a syntax error when ./install is run from a
# tmux pane. A shebang pins the interpreter regardless of the caller's shell.
#
# No-ops with a message when the rclone remote is absent, so ./install stays
# safe on a machine that has never been set up for tuxcloud. The credential is
# per-machine and deliberately not in this repo - see docs/TUXCLOUD.md.
set -euo pipefail

UNIT="rclone-tuxcloud.service"
MOUNT="$HOME/cloud"
BOOKMARKS="$HOME/.config/gtk-3.0/bookmarks"

if ! rclone listremotes 2>/dev/null | grep -qx 'tuxcloud:'; then
  echo "skip: rclone remote 'tuxcloud:' not configured (see docs/TUXCLOUD.md)"
  exit 0
fi

# systemd user unit
mkdir -p "$HOME/.config/systemd/user" "$MOUNT"
ln -sf "$HOME/.dotfiles/systemd/user/$UNIT" "$HOME/.config/systemd/user/$UNIT"
systemctl --user daemon-reload
# Tolerated: the server is LAN-only, so enable --now fails off-LAN. The unit
# stays enabled and systemd retries on the next login or network return.
systemctl --user enable --now "$UNIT" || echo "warn: could not start $UNIT (off-LAN?); enabled for next boot"

# Nautilus sidebar bookmark
mkdir -p "$(dirname "$BOOKMARKS")"
touch "$BOOKMARKS"
grep -qF "file://$MOUNT " "$BOOKMARKS" || echo "file://$MOUNT tuxcloud" >>"$BOOKMARKS"
