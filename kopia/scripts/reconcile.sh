#!/usr/bin/env bash
# Reconciles the desktop Kopia setup from any state. Idempotent.
#
# What it does:
#   1. Loads config from ~/.config/kopia/env
#   2. Ensures the repo exists + is connected (create or connect via SFTP)
#   3. Applies retention + compression + schedule policy for $USER@$hostname
#   4. Rebuilds ignore rules from ignore-patterns.txt
#   5. Registers new sources (in sources.txt, not yet known to Kopia)
#   6. Reports orphan sources (in Kopia, not in sources.txt) with the
#      exact delete command to run
#
# Safe to run anytime. First run on a clean machine = full setup.
# Re-run after editing sources.txt or ignore-patterns.txt.
set -euo pipefail

DOTFILES_KOPIA="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/env"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kopia/sftp.config"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing $ENV_FILE - see kopia/README.md" >&2
    exit 1
fi
# shellcheck disable=SC1090
source "$ENV_FILE"
: "${KOPIA_PASSWORD:?must be set in $ENV_FILE}"
export KOPIA_PASSWORD

: "${KOPIA_SFTP_HOST:?must be set in $ENV_FILE}"
: "${KOPIA_SFTP_BASE:?must be set in $ENV_FILE}"
SFTP_HOST="$KOPIA_SFTP_HOST"
SFTP_PORT="${KOPIA_SFTP_PORT:-22}"
SFTP_USER="${KOPIA_SFTP_USER:-kopia}"
SFTP_BASE="$KOPIA_SFTP_BASE"
HOSTNAME_SHORT="$(hostname -s)"
SFTP_PATH="$SFTP_BASE/$HOSTNAME_SHORT"
USER_HOST="$USER@$HOSTNAME_SHORT"

mkdir -p "$(dirname "$CONFIG_FILE")"
K() { kopia --config-file="$CONFIG_FILE" "$@"; }

# ---- ensure repo ----
if ! K repository status >/dev/null 2>&1; then
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

# ---- apply policy + schedule ----
K policy set "$USER_HOST" \
    --keep-latest=10 \
    --keep-hourly=24 \
    --keep-daily=30 \
    --keep-weekly=12 \
    --keep-monthly=24 \
    --keep-annual=5 \
    --compression=zstd-fastest \
    --snapshot-interval=3h0m0s

# ---- rebuild ignore rules ----
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

# ---- source reconciliation ----
PATHS=()
while IFS= read -r line; do
    trimmed="${line%%#*}"
    trimmed="${trimmed#"${trimmed%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    [[ -z "$trimmed" ]] && continue
    expanded="${trimmed/#\~/$HOME}"
    [[ -d "$expanded" ]] && PATHS+=("$expanded") || echo "skip (missing): $expanded" >&2
done < "$DOTFILES_KOPIA/sources.txt"

WANTED=$(printf '%s\n' "${PATHS[@]}" | sort -u)
EXISTING=$(K snapshot list --all --json 2>/dev/null \
    | jq -r --arg u "$USER" --arg h "$HOSTNAME_SHORT" \
        '.[] | select(.source.userName == $u and .source.host == $h) | .source.path' \
    | sort -u) || EXISTING=""

NEW=$(comm -23 <(echo "$WANTED") <(echo "$EXISTING") | grep -v '^$' || true)
ORPHANS=$(comm -13 <(echo "$WANTED") <(echo "$EXISTING") | grep -v '^$' || true)

if [[ -n "$NEW" ]]; then
    echo ""
    echo "Registering new sources (first snapshot):"
    printf '  %s\n' $NEW
    mapfile -t NEW_PATHS <<< "$NEW"
    K snapshot create "${NEW_PATHS[@]}"
fi

if [[ -n "$ORPHANS" ]]; then
    echo ""
    echo "Orphan sources (registered in Kopia but not in sources.txt):"
    printf '  %s\n' $ORPHANS
    echo ""
    echo "To unregister + delete all their snapshots, run:"
    while IFS= read -r p; do
        echo "  kopia --config-file=\"$CONFIG_FILE\" snapshot delete \\"
        echo "    --all-snapshots-for-source \"$USER_HOST:$p\" --delete"
    done <<< "$ORPHANS"
fi

echo ""
echo "Reconciled $USER_HOST"
