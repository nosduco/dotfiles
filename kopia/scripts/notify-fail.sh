#!/usr/bin/env bash
# Called by systemd OnFailure= hook. Posts the failing unit's last journal
# lines to ntfy. Silently no-ops if ntfy creds aren't configured.
set -euo pipefail

ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/env"
[[ -f "$ENV_FILE" ]] || exit 0
# shellcheck disable=SC1090
source "$ENV_FILE"
[[ -n "${NTFY_URL:-}" && -n "${NTFY_USER:-}" && -n "${NTFY_PASSWORD:-}" ]] || exit 0

UNIT="${1:-unknown}"
HOST="$(hostname -s)"
TAIL="$(journalctl --user -u "$UNIT" -n 30 --no-pager 2>/dev/null | tail -20)"

curl -fsSL -u "$NTFY_USER:$NTFY_PASSWORD" \
    -H "Title: Kopia backup failed on $HOST ($UNIT)" \
    -H "Priority: high" \
    -H "Tags: kopia,desktop,warning" \
    -d "$TAIL" \
    "$NTFY_URL" >/dev/null
