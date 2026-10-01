# Caffeine toggle for waybar. Takes a systemd inhibitor lock covering
# idle, sleep, and lid-switch handling, so with caffeine on the laptop
# runs clamshell (lid closed, no suspend). logind always honors
# handle-lid-switch locks, so no logind.conf changes are needed.

TAG="waybar-caffeine"

running() {
  pgrep -f "^systemd-inhibit .*--who=$TAG" >/dev/null
}

case "$1" in
  toggle)
    if running; then
      pkill -f "$TAG hold\$" || true
      pkill -f "^systemd-inhibit .*--who=$TAG" || true
    else
      systemd-inhibit --what=idle:sleep:handle-lid-switch --who="$TAG" \
        --why="caffeine: keep system awake (clamshell ok)" "$0" hold &
      disown
    fi
    pkill -RTMIN+8 -x waybar
    ;;
  hold)
    if [[ -z ${LOW:-} ]]; then
      exec sleep infinity
    fi
    bat=(/sys/class/power_supply/BAT*/capacity)
    while systemd-ac-power || [[ $(<"${bat[0]}") -gt $LOW ]]; do
      sleep 60
    done
    notify-send -u critical "Caffeine off" "Battery low, sleep allowed again"
    (sleep 1 && pkill -RTMIN+8 -x waybar) &
    ;;
  status)
    if running; then
      printf '{"alt":"activated","class":"activated","tooltip":"Caffeine on: idle/sleep/lid suspend blocked"}\n'
    else
      printf '{"alt":"deactivated","class":"deactivated","tooltip":"Caffeine off"}\n'
    fi
    ;;
  *)
    echo "usage: $0 {toggle|status|hold}" >&2
    exit 1
    ;;
esac
