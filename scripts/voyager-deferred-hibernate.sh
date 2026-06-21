#!/bin/bash
# Fixed-delay suspend->hibernate. systemd's suspend-then-hibernate is broken on
# this box (no usable ACPI _BTP), so this system-sleep hook does it instead: on
# a battery suspend, set a deadline (first lid-close + DELAY) and arm the RTC.
# The firmware wakes from s2idle every ~30min, so we re-suspend until the
# deadline passes, then hibernate. Reset on lid-open or AC. See docs/VOYAGER.md.

set -u

DELAY=7200
SLACK=60
RTC=/sys/class/rtc/rtc0/wakealarm
STAMP=/run/voyager-deferred-hibernate.deadline

on_battery() { [ "$(cat /sys/class/power_supply/A*/online 2>/dev/null | head -1)" = "0" ]; }
lid_open()   { grep -qi open /proc/acpi/button/lid/*/state 2>/dev/null; }

arm_rtc() {
    local when="$1" now; now=$(date +%s)
    [ "$when" -lt "$(( now + 30 ))" ] && when=$(( now + 30 ))
    echo 0 > "$RTC" 2>/dev/null
    echo "$when" > "$RTC" 2>/dev/null
}

case "$1" in
    pre)
        { [ "$2" = "suspend" ] && on_battery; } || exit 0
        now=$(date +%s); deadline=$(cat "$STAMP" 2>/dev/null || echo 0)
        if [ "$deadline" -eq 0 ] || [ "$now" -gt "$(( deadline + 120 ))" ]; then
            deadline=$(( now + DELAY ))
            echo "$deadline" > "$STAMP"
            logger -t voyager-hibernate "hibernating at deadline (+${DELAY}s) unless lid opens"
        fi
        arm_rtc "$deadline"
        ;;
    post)
        { [ "$2" = "suspend" ] && [ -e "$STAMP" ]; } || exit 0
        if lid_open || ! on_battery; then
            rm -f "$STAMP"; echo 0 > "$RTC" 2>/dev/null; exit 0
        fi
        now=$(date +%s); deadline=$(cat "$STAMP" 2>/dev/null || echo 0)
        if [ "$(( deadline - now ))" -le "$SLACK" ]; then
            rm -f "$STAMP"; echo 0 > "$RTC" 2>/dev/null
            logger -t voyager-hibernate "deadline reached, hibernating"
            # via timer, not inline: an inline hibernate is dropped mid-resume
            # and logind's 30s holdoff re-suspends instead
            systemd-run --on-active=3 --timer-property=AccuracySec=1s systemctl hibernate
        fi
        ;;
esac
exit 0
