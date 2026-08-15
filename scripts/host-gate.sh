#!/bin/bash
# Run a shell command only on a named host.
#
#   ./scripts/host-gate.sh <hostname> "<command>"
#
# Why this exists: dotbot implements `if:` only in its link plugin
# (dotbot/src/dotbot/plugins/link.py). The shell plugin parses just
# command/description/stdin/stdout/stderr/quiet and silently drops any other
# key, so `if:` on a shell entry is a no-op that reads like a working gate.
# Between 2026-05-24 and 2026-08-15 that put voyager's power tuning on
# nighthawk on every ./install.
#
# The command is run through `bash -c` rather than exec'd directly, because the
# entries it wraps are compound shell (&&, ||, redirects). That also pins the
# interpreter: dotbot runs commands via "$SHELL", and .tmux.conf sets tmux
# default-shell to fish, so POSIX syntax is not safe to assume.
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: host-gate.sh <hostname> <command...>" >&2
  exit 2
fi

want="$1"
shift

if [ "$(hostname)" != "$want" ]; then
  echo "skip: host is $(hostname), not $want"
  exit 0
fi

exec bash -c "$*"
