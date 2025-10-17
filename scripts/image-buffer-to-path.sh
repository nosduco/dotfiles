#!/usr/bin/env bash
set -e
if [ -n "$WAYLAND_DISPLAY" ]; then
    types=$(wl-paste --list-types)
    if grep -q '^image/' <<<"$types"; then
        ext=$(grep -m1 '^image/' <<<"$types" | cut -d/ -f2 | cut -d';' -f1)
        file="/tmp/clip_$(date +%s).${ext}"
        wl-paste > "$file"
        printf '%q' "$file"
    else
        wl-paste --no-newline
    fi
elif [ -n "$DISPLAY" ]; then
    types=$(xclip -selection clipboard -t TARGETS -o)
    if grep -q '^image/' <<<"$types"; then
        ext=$(grep -m1 '^image/' <<<"$types" | cut -d/ -f2 | cut -d';' -f1)
        file="/tmp/clip_$(date +%s).${ext}"
        xclip -selection clipboard -t "image/${ext}" -o > "$file"
        printf '%q' "$file"
    else
        xclip -selection clipboard -o
    fi
fi
