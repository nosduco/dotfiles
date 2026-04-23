#!/usr/bin/env bash
# Ensures the primary Kopia repo (SFTP to tux) exists + is connected, then
# applies declarative policy/sources from dotfiles. Reads all config from
# ~/.config/kopia/env (see kopia/README.md). Safe to re-run.
set -euo pipefail

ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/env"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/tux-sftp.config"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing $ENV_FILE - see kopia/README.md" >&2
    exit 1
fi
# shellcheck disable=SC1090
source "$ENV_FILE"
: "${KOPIA_PASSWORD:?must be set in $ENV_FILE}"
export KOPIA_PASSWORD

SFTP_HOST="${KOPIA_SFTP_HOST:-tux}"
SFTP_PORT="${KOPIA_SFTP_PORT:-22}"
SFTP_USER="${KOPIA_SFTP_USER:-kopia}"
SFTP_BASE="${KOPIA_SFTP_BASE:-/tank/data/backups/endpoints}"

HOSTNAME_SHORT="$(hostname -s)"
SFTP_PATH="$SFTP_BASE/$HOSTNAME_SHORT"

mkdir -p "$(dirname "$CONFIG_FILE")"
K() { kopia --config-file="$CONFIG_FILE" "$@"; }

if ! K repository status >/dev/null 2>&1; then
    # --external shells out to real `ssh` so it picks up ssh-agent
    # (gnome-keyring unlocks passphrase-protected keys on login).
    SFTP_ARGS=(
        --host="$SFTP_HOST"
        --port="$SFTP_PORT"
        --username="$SFTP_USER"
        --path="$SFTP_PATH"
        --external
        --persist-credentials
    )

    if K repository connect sftp "${SFTP_ARGS[@]}" 2>/dev/null; then
        echo "Connected to existing repo at sftp://$SFTP_USER@$SFTP_HOST:$SFTP_PATH"
    else
        echo "Creating new repo at sftp://$SFTP_USER@$SFTP_HOST:$SFTP_PATH"
        K repository create sftp "${SFTP_ARGS[@]}" \
            --override-hostname="$HOSTNAME_SHORT" \
            --override-username="$USER"
    fi
fi

"$(dirname "$0")/apply-policies.sh" "$CONFIG_FILE"
