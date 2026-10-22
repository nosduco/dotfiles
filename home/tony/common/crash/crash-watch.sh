
declare -A last

diagnose() {
  local pid=$1 comm=$2 signal=$3 action
  action=$(notify-send -u critical -a Crash -A default=Diagnose \
    "$comm crashed" "$signal, PID $pid. Middle-click to diagnose") || return 0
  [[ $action == default ]] || return 0
  uwsm app -- ghostty --working-directory="$HOME/.dotfiles" -e claude \
    "The program '$comm' crashed with $signal (PID $pid). Read the report with 'coredumpctl info $pid'. For a symbolized backtrace run: coredumpctl debug $pid --debugger-arguments='-batch -iex \"set debuginfod enabled on\" -ex \"thread apply all bt\"'. Find the root cause and propose a fix. Change nothing until I agree."
}

journalctl -f -n 0 -o json MESSAGE_ID=fc2e22bc6ee647b6b90729ab34a250b1 |
  jq --unbuffered -r '[.COREDUMP_PID, .COREDUMP_COMM, .COREDUMP_EXE, .COREDUMP_SIGNAL_NAME] | map(if . == null or . == "" then "-" else . end) | @tsv' |
  while IFS=$'\t' read -r pid comm exe signal; do
    case "$exe" in
      */Steam/* | */steamapps/*) continue ;;
    esac
    now=$(date +%s)
    ((now - ${last[$exe]:-0} < 60)) && continue
    last[$exe]=$now
    diagnose "$pid" "$comm" "$signal" &
  done
