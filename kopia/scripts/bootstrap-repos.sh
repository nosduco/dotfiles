#!/usr/bin/env bash
# Ensures the primary Kopia repo (SFTP to tux) exists and is connected.
# Reads KOPIA_PASSWORD from ~/.config/kopia/env — no interactive prompts.
# Safe to re-run: no-ops if already connected, auto-connects if the repo
# exists remotely but this machine's config was wiped.
set -euo pipefail

ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/env"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/tux-sftp.config"
HOSTNAME_SHORT="$(hostname -s)"
SFTP_PATH="/tank/data/backups/endpoints/$HOSTNAME_SHORT"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing $ENV_FILE - see kopia/README.md" >&2
    exit 1
fi
# shellcheck disable=SC1090
source "$ENV_FILE"
: "${KOPIA_PASSWORD:?must be set in $ENV_FILE}"
export KOPIA_PASSWORD

mkdir -p "$(dirname "$CONFIG_FILE")"
K() { kopia --config-file="$CONFIG_FILE" "$@"; }

if K repository status >/dev/null 2>&1; then
    exit 0
fi

SFTP_ARGS=(
    --host=tux
    --port=22
    --username=kopia
    --path="$SFTP_PATH"
    --keyfile="$HOME/.ssh/id_ed25519"
    --known-hosts="$HOME/.ssh/known_hosts"
    --persist-credentials
)

if K repository connect sftp "${SFTP_ARGS[@]}" 2>/dev/null; then
    echo "Connected to existing repo at sftp://kopia@tux:$SFTP_PATH"
else
    echo "Creating new repo at sftp://kopia@tux:$SFTP_PATH"
    K repository create sftp "${SFTP_ARGS[@]}" \
        --override-hostname="$HOSTNAME_SHORT" \
        --override-username="$USER"
fi
