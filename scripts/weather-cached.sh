#!/usr/bin/env bash
# tmux re-runs status-right every status-interval tick (1s) per attached client.
# Serve from a cache so wttr.in sees ~48 requests/day instead of ~86k.
set -u

location="${1:-Columbus}"
cachedir="$HOME/.cache/weather"
cache="$cachedir/tmux-$location"
max_age=1800

mkdir -p "$cachedir"

age=$max_age
if [[ -f "$cache" ]]; then
    age=$(( $(date +%s) - $(stat -c %Y "$cache") ))
fi

if (( age >= max_age )); then
    fresh=$(curl -s --max-time 5 "https://wttr.in/${location}?format=%c%t" 2>/dev/null)
    if [[ -n "$fresh" && "$fresh" != *"Unknown"* && "$fresh" != *"Sorry"* ]]; then
        printf '%s\n' "$fresh" > "$cache.tmp" && mv "$cache.tmp" "$cache"
    else
        touch "$cache" 2>/dev/null
    fi
fi

[[ -s "$cache" ]] && cat "$cache"
exit 0
