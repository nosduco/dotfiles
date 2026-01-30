#!/usr/bin/env bash
dispatch() {
    hyprctl dispatch "$@" > /dev/null 2>&1
}

# Poll until a window with matching class exists.
await_class() {
    local pattern="$1"
    local i=0
    while [ $i -lt 200 ]; do
        if hyprctl clients -j 2>/dev/null | jq -e ".[] | select(.class == \"$pattern\")" > /dev/null 2>&1; then
            return 0
        fi
        sleep 0.05
        i=$((i + 1))
    done
    return 1
}

# Poll until ghostty window count increases.
await_new_ghostty() {
    local before="$1"
    local i=0
    while [ $i -lt 200 ]; do
        local now
        now=$(hyprctl clients -j 2>/dev/null | jq '[.[] | select(.class == "com.mitchellh.ghostty")] | length' 2>/dev/null || echo 0)
        if [ "$now" -gt "$before" ]; then
            return 0
        fi
        sleep 0.05
        i=$((i + 1))
    done
    return 1
}

# ---------------------------------------------------------------------------
# Left monitor (vertical)
# ---------------------------------------------------------------------------

dispatch workspace right-monitor

# 1. Discord (fills workspace)
uwsm app -- vesktop &
await_class vesktop || true
dispatch focuswindow class:vesktop

# 2. Preselect down, launch btop -> Vesktop top, btop bottom
ghostty_count=$(hyprctl clients -j 2>/dev/null | jq '[.[] | select(.class == "com.mitchellh.ghostty")] | length' 2>/dev/null || echo 0)
dispatch layoutmsg preselect d
uwsm app -- ghostty -e btop &
await_new_ghostty "$ghostty_count" || true

# 3. Focus Discord, preselect down -> Claude inserts between Vesktop and btop
dispatch focuswindow class:vesktop
dispatch layoutmsg preselect d
uwsm app -- firefoxpwa site launch 01KBH7FDJN0SMRXM47M6HHR694 &
await_class FFPWA-01KBH7FDJN0SMRXM47M6HHR694 || true

# 4. Focus Claude, preselect right -> Telegram beside Claude
dispatch focuswindow class:FFPWA-01KBH7FDJN0SMRXM47M6HHR694
dispatch layoutmsg preselect r
uwsm app -- Telegram &
await_class org.telegram.desktop || true

# 5. Adjust splits
dispatch focuswindow class:org.telegram.desktop
dispatch movefocus d
dispatch resizeactive 0 705

# Grow Vesktop
dispatch focuswindow class:vesktop
dispatch resizeactive 0 -127

# ---------------------------------------------------------------------------
# Main monitor
# ---------------------------------------------------------------------------

dispatch workspace 1

uwsm app -- firefox &
await_class firefox || true
dispatch focuswindow class:firefox

dispatch layoutmsg preselect r
uwsm app -- obsidian &
await_class obsidian || true

dispatch focuswindow class:firefox
dispatch resizeactive 997 0

# ---------------------------------------------------------------------------
# Top monitor
# ---------------------------------------------------------------------------

uwsm app -- spotify-launcher &
await_class spotify || true
dispatch movetoworkspacesilent name:top-monitor,class:spotify

# ---------------------------------------------------------------------------
dispatch workspace 1
