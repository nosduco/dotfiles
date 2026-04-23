#!/usr/bin/env bash
# Called by systemd OnFailure= hook. Shows a desktop notification.
set -euo pipefail

UNIT="${1:-unknown}"
TAIL="$(journalctl --user -u "$UNIT" -n 5 --no-pager 2>/dev/null | tail -3)"

notify-send \
    --urgency=critical \
    --app-name=Kopia \
    --icon=dialog-warning \
    "Kopia backup failed: $UNIT" \
    "$TAIL"
