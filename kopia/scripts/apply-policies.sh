#!/usr/bin/env bash
# Reconciles Kopia repo against the declarative config in ~/.dotfiles/kopia/:
# retention, compression, ignore rules, sources. Idempotent.
set -euo pipefail

DOTFILES_KOPIA="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/env"
CONFIG_FILE="${1:-$HOME/.config/kopia/tux-sftp.config}"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Config missing ($CONFIG_FILE). Run bootstrap-repos.sh first." >&2
    exit 1
fi
if [[ -f "$ENV_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$ENV_FILE"
    export KOPIA_PASSWORD
fi

K() { kopia --config-file="$CONFIG_FILE" "$@"; }

if ! K repository status >/dev/null 2>&1; then
    echo "Not connected. Run bootstrap-repos.sh." >&2
    exit 1
fi

USER_HOST="$USER@$(hostname -s)"

K policy set "$USER_HOST" \
    --keep-latest=10 \
    --keep-hourly=0 \
    --keep-daily=30 \
    --keep-weekly=12 \
    --keep-monthly=24 \
    --keep-annual=5 \
    --compression=zstd-fastest \
    --manual

mapfile -t CURRENT < <(K policy show "$USER_HOST" --json 2>/dev/null \
    | jq -r '.files.ignore[]?' 2>/dev/null || true)

ARGS=()
for p in "${CURRENT[@]:-}"; do
    [[ -n "$p" ]] && ARGS+=(--remove-ignore "$p")
done
while IFS= read -r line; do
    trimmed="${line%%#*}"
    trimmed="${trimmed#"${trimmed%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    [[ -z "$trimmed" ]] && continue
    ARGS+=(--add-ignore "$trimmed")
done < "$DOTFILES_KOPIA/ignore-patterns.txt"

((${#ARGS[@]} > 0)) && K policy set "$USER_HOST" "${ARGS[@]}"

PATHS=()
while IFS= read -r line; do
    trimmed="${line%%#*}"
    trimmed="${trimmed#"${trimmed%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    [[ -z "$trimmed" ]] && continue
    expanded="${trimmed/#\~/$HOME}"
    [[ -d "$expanded" ]] && PATHS+=("$expanded") || echo "skip (missing): $expanded" >&2
done < "$DOTFILES_KOPIA/sources.txt"

((${#PATHS[@]} > 0)) && K snapshot create "${PATHS[@]}"
