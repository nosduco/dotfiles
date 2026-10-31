
DIR="$(xdg-user-dir VIDEOS)"
LAST="$XDG_RUNTIME_DIR/record-last"
PORT=18080
REFRESH=(--user kill --kill-whom=main -s SIGRTMIN+10 waybar)

running() {
  systemctl --user is-active -q "$1"
}

start() {
  local monitor
  monitor="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"
  systemd-run --user -q --collect --unit="$1" -p ExecStopPost="-$(command -v systemctl) ${REFRESH[*]}" \
    gpu-screen-recorder -w "$monitor" -f 60 -a "default_output|default_input" "${@:2}"
  systemctl "${REFRESH[@]}" || true
}

stop() {
  systemctl --user kill -s INT "$1"
  while running "$1"; do
    sleep 0.2
  done
}

finish() {
  stop record
  file="$(<"$LAST")"
  "$SHARE" "$file" &
  running record-exports || systemd-run --user -q --collect --unit=record-exports "$0" exports
  exec uwsm app -- losslesscut --http-api="$PORT" -- "$file"
}

case "${1:-clip}" in
  clip)
    if running record; then
      finish
    else
      mkdir -p "$DIR/recordings"
      echo "$DIR/recordings/recording-$(date +'%Y-%m-%d_%H-%M-%S').mp4" >"$LAST"
      start record -o "$(<"$LAST")"
    fi
    ;;
  replay)
    if running replay; then
      stop replay
      notify-send -t 2000 "Replay" "Off"
    else
      mkdir -p "$DIR/replays"
      start replay -c mp4 -r 60 -sc "$SHARE" -o "$DIR/replays"
      notify-send -t 2000 "Replay" "On: keeping the last 60 seconds"
    fi
    ;;
  save)
    if running replay; then
      systemctl --user kill -s USR1 replay
      notify-send -t 2000 "Replay" "Saved to $DIR/replays"
    fi
    ;;
  stop)
    if running record; then
      finish
    elif running replay; then
      stop replay
    fi
    ;;
  exports)
    while json="$(curl -sf --retry 30 --retry-connrefused --retry-delay 1 -X POST "http://127.0.0.1:$PORT/api/await-event/export-complete")"; do
      jq -r '.paths[]?' <<<"$json" | while read -r path; do
        "$SHARE" "$path"
      done
    done
    ;;
  status)
    if running record; then
      printf '{"alt":"recording","class":"recording","tooltip":"Recording: click to stop"}\n'
    elif running replay; then
      printf '{"alt":"replay","class":"replay","tooltip":"Replay on: click to turn off"}\n'
    fi
    ;;
esac
