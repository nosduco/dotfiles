STATE="$XDG_RUNTIME_DIR/gammastep-period"

case "$1" in
  period-changed)
    echo "$3" >"$STATE"
    systemctl --user kill --kill-whom=main -s SIGRTMIN+9 waybar || true
    ;;
  toggle)
    systemctl --user kill --kill-whom=main -s SIGUSR1 gammastep
    ;;
  status)
    case "$(cat "$STATE" 2>/dev/null)" in
      night | transition) printf '{"alt":"on","tooltip":"Night light on"}\n' ;;
      none) printf '{"alt":"off","tooltip":"Night light off"}\n' ;;
    esac
    ;;
esac
