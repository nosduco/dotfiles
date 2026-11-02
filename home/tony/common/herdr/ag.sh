# usage: ag [-d] <agent> [args] | ag -a <machine> <terminal> <agent> <dir> | ag -c | ag

target() {
  herdr machine list --json | jq -r --arg m "$1" '.[] | select(.label == $m) | .target'
}

agents() {
  local machine=$1
  shift
  { "$@" workspace list && "$@" agent list; } 2>/dev/null | jq -rs --arg m "$machine" '
    def pad(n): (. + " " * n)[:n];
    ((.[0].result.workspaces? // []) | map({(.workspace_id): .label}) | add // {}) as $ws
    | (.[1].result.agents? // [])[]
    | [$m, .terminal_id, .agent, .cwd,
       ($m | pad(10)) + ($ws[.workspace_id] // .workspace_id | pad(16)) + (.agent | pad(8)) + (.agent_status | pad(9)) + .terminal_title_stripped]
    | @tsv' || true
}

start() {
  agent=$1
  shift
  local dir=$PWD ws created
  ws=$(herdr pane list | jq -r --arg d "$dir" 'first(.result.panes[] | select(.cwd == $d) | .workspace_id) // empty')
  if [ -n "$ws" ]; then
    created=$(herdr tab create --workspace "$ws" --cwd "$dir" --label "$agent" --no-focus)
  else
    created=$(herdr workspace create --cwd "$dir" --label "$(basename "$dir")" --no-focus)
    herdr tab rename "$(jq -r .result.tab.tab_id <<<"$created")" "$agent" >/dev/null
  fi
  term=$(jq -r .result.root_pane.terminal_id <<<"$created")
  herdr pane run "$(jq -r .result.root_pane.pane_id <<<"$created")" "exec $(printf '%q ' "$agent" "$@")" >/dev/null
}

mark() {
  [ -n "${TMUX_PANE:-}" ] || return 0
  win=$(tmux display -p -t "$TMUX_PANE" '#{window_id}')
  tmux set -p -t "$TMUX_PANE" @ag_host "$1" \; set -p -t "$TMUX_PANE" @ag_term "$2" \; \
    set -p -t "$TMUX_PANE" @ag_agent "$3" \; set -p -t "$TMUX_PANE" @ag_dir "$(basename "$4")" \; \
    set -p -t "$TMUX_PANE" @ag_target "$5" \; set -w -t "$win" pane-border-status top
  trap unmark EXIT
}

unmark() {
  tmux set -pu -t "$TMUX_PANE" @ag_host \; set -pu -t "$TMUX_PANE" @ag_term \; \
    set -pu -t "$TMUX_PANE" @ag_agent \; set -pu -t "$TMUX_PANE" @ag_dir \; \
    set -pu -t "$TMUX_PANE" @ag_target 2>/dev/null || true
  [ -n "$(tmux list-panes -t "$win" -f '#{@ag_host}' -F x 2>/dev/null)" ] ||
    tmux set -wu -t "$win" pane-border-status 2>/dev/null || true
}

attach() {
  local machine=$1 term=$2 target=""
  [ "$machine" = "$HOSTNAME" ] || target=$(target "$machine")
  mark "$machine" "$term" "$3" "$4" "$target"
  if [ -z "$target" ]; then
    pane=$(herdr pane list | jq -r --arg t "$term" '.result.panes[] | select(.terminal_id == $t) | .pane_id')
    trap 'herdr pane close "$pane" >/dev/null 2>&1' HUP
    herdr terminal attach "$term" || true
  else
    ssh -t "$target" herdr terminal attach "$term" || true
  fi
}

count() {
  local shown
  shown=$(tmux list-panes -a -F '#{@ag_term}' | jq -Rs 'split("\n")')
  herdr agent list 2>/dev/null | jq -r --argjson s "$shown" '[.result.agents[] | select(.terminal_id | IN($s[]) | not)] | length' || true
}

case ${1:-} in
"")
  sel=$(
    {
      agents "$HOSTNAME" herdr
      herdr machine list --json | jq -r '.[] | select(.enabled) | .label' | while read -r m; do
        agents "$m" herdr --machine "$m"
      done
    } | fzf --delimiter='\t' --with-nth=5 --no-sort --prompt='agent> '
  ) || exit 0
  IFS=$'\t' read -r machine term agent dir _ <<<"$sel"
  attach "$machine" "$term" "$agent" "$dir"
  ;;
-a)
  attach "$2" "$3" "$4" "$5"
  ;;
-c)
  count
  ;;
-d)
  shift
  start "$@"
  echo "$term"
  ;;
*)
  start "$@"
  attach "$HOSTNAME" "$term" "$agent" "$PWD"
  ;;
esac
