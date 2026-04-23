#!/usr/bin/env bash
# Daily snapshot: auto-bootstraps the repo if creds are present, then
# reconciles policy + snapshots all sources. No-op if creds are missing.
set -euo pipefail

ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/env"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/tux-sftp.config"
SCRIPT_DIR="$(dirname "$0")"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "kopia not configured (missing $ENV_FILE), skipping"
    exit 0
fi

"$SCRIPT_DIR/bootstrap-repos.sh"
exec "$SCRIPT_DIR/apply-policies.sh" "$CONFIG_FILE"
