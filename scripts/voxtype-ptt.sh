#!/usr/bin/env bash
# Voxtype push-to-talk: pause MPRIS player while recording, resume if it was playing.
set -u

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/voxtype-was-playing"

case "${1:-}" in
  start)
    if [ "$(playerctl status 2>/dev/null)" = "Playing" ]; then
      playerctl pause 2>/dev/null || true
      touch "$STATE_FILE"
    fi
    exec voxtype record start
    ;;
  stop)
    voxtype record stop
    if [ -f "$STATE_FILE" ]; then
      rm -f "$STATE_FILE"
      playerctl play 2>/dev/null || true
    fi
    ;;
  *)
    echo "usage: $0 {start|stop}" >&2
    exit 2
    ;;
esac
