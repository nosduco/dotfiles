# AWS Client VPN on headless daemon. The CLI opens the SAML login with
# xdg-open, so a stand-in xdg-open saves the URL and this prints it instead.
# The login redirects to 127.0.0.1:35001, which the laptops forward here with
# `ssh daemon-work-vpn` (home/tony/desktop/work.nix); that alias runs `up`.

PROFILE=edge-internal
SOCKET=/run/awsvpnclient/com.aws.vpn-client.daemon.sock

running() {
  systemctl is-active --quiet awsvpnclient.service
}

state() {
  aws-vpn-client get-connection-status --profile-name "$PROFILE" 2>/dev/null |
    jq -r '."connection-status" // "Unknown"' || echo Unknown
}

connected() {
  [ "$(state)" = Connected ]
}

# wait_for SECONDS CMD...: retry CMD once a second until it succeeds or time runs out
wait_for() {
  local deadline=$((SECONDS + $1))
  shift
  until "$@"; do
    ((SECONDS < deadline)) || return 1
    sleep 1
  done
}

up() {
  if running && connected; then
    echo "Already connected to $PROFILE"
    return
  fi

  systemctl start awsvpnclient.service
  if ! wait_for 10 test -S "$SOCKET"; then
    echo "awsvpnclient daemon did not come up" >&2
    exit 1
  fi

  # A login left waiting by an earlier run blocks a new one. A freshly started
  # daemon answers "Profile is not connected", so only clear known in-flight states
  case "$(state)" in
    WaitingForIdentity | Connecting | Reconnecting | Warning)
      aws-vpn-client disconnect --profile-name "$PROFILE" >/dev/null 2>&1 || true
      ;;
  esac

  shim=$(mktemp -d)
  trap 'rm -rf "$shim"' EXIT
  cat >"$shim/xdg-open" <<EOF
#!/bin/sh
printf '%s\n' "\$1" >"$shim/url"
EOF
  chmod +x "$shim/xdg-open"

  PATH="$shim:$PATH" aws-vpn-client connect --profile-name "$PROFILE" >/dev/null
  if ! wait_for 20 test -s "$shim/url"; then
    echo "No SAML login URL after 20s (status: $(state))" >&2
    exit 1
  fi

  echo "Log in from a machine forwarding 127.0.0.1:35001 here (ssh daemon-work-vpn):"
  echo
  cat "$shim/url"
  echo

  if wait_for 300 connected; then
    echo "Connected to $PROFILE"
  else
    echo "Not connected after 5 minutes (status: $(state))" >&2
    exit 1
  fi
}

down() {
  if running; then
    aws-vpn-client disconnect --profile-name "$PROFILE" >/dev/null 2>&1 || true
    systemctl stop awsvpnclient.service
  fi
  echo "Disconnected from $PROFILE"
}

status() {
  if running; then
    echo "$PROFILE: $(state)"
  else
    echo "$PROFILE: Disconnected (daemon stopped)"
  fi
}

case "${1:-status}" in
  up) up ;;
  down) down ;;
  status) status ;;
  *)
    echo "usage: work-vpn [up|down|status]" >&2
    exit 2
    ;;
esac
