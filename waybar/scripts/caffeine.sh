#!/usr/bin/env bash
# Caffeine toggle for waybar. Takes a systemd inhibitor lock covering
# idle, sleep, and lid-switch handling, so with caffeine on the laptop
# runs clamshell (lid closed, no suspend). logind always honors
# handle-lid-switch locks, so no logind.conf changes are needed.

TAG="waybar-caffeine"

running() {
  pgrep -f "systemd-inhibit.*$TAG" >/dev/null
}

case "$1" in
  toggle)
    if running; then
      pkill -f "systemd-inhibit.*$TAG"
    else
      systemd-inhibit --what=idle:sleep:handle-lid-switch --who="$TAG" \
        --why="caffeine: keep system awake (clamshell ok)" sleep infinity &
      disown
    fi
    pkill -RTMIN+8 waybar
    ;;
  status)
    if running; then
      printf '{"alt":"activated","class":"activated","tooltip":"Caffeine on: idle/sleep/lid suspend blocked"}\n'
    else
      printf '{"alt":"deactivated","class":"deactivated","tooltip":"Caffeine off"}\n'
    fi
    ;;
  *)
    echo "usage: $0 {toggle|status}" >&2
    exit 1
    ;;
esac
