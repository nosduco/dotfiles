# usage: tp <tmux pane> | tp files <agent> <session>

say() {
  tmux display-message -d 4000 "tp: $*"
  exit 0
}

on() {
  local host=$1
  shift
  if [ "$host" = local ]; then "$@"; else ssh -n "$target" "$@"; fi
}

name() {
  if [ "$1" = local ]; then echo "$HOSTNAME"; else echo "$machine"; fi
}

resume() {
  case $agent in
  claude) args=(--resume "$session") ;;
  codex) args=(resume "$session") ;;
  pi) args=(--session "$session") ;;
  *) return 1 ;;
  esac
}

files() {
  cd "$HOME" || return
  case $1 in
  claude) find .claude/projects -mindepth 2 -maxdepth 2 -name "$2*" ;;
  codex) find .codex/sessions -name "*$2.jsonl" ;;
  pi) case $2 in /*) echo "${2#"$HOME"/}" ;; *) find .pi/agent/sessions -name "*_$2.jsonl" ;; esac ;;
  esac
}

copy() {
  local from=$1 to=$1
  shift
  if [ "$src" = local ]; then to=$target:$to; else from=$target:$from; fi
  rsync -a --backup "$@" "$from" "$to"
}

sync() {
  local list
  why="copying $dir failed"
  copy "$dir/" --delete --mkpath --backup-dir="$bk/files" --info=progress2 || return 1
  why="no session files for $session"
  list=$(on "$src" tp files "$agent" "$session") && [ -n "$list" ] || return 1
  why="copying the session failed"
  copy "$HOME/" -r --backup-dir="$bk/sessions" --files-from=- <<<"$list"
}

go() {
  if [ "$1" = local ]; then
    why="starting $agent on $HOSTNAME failed"
    ag "$agent" "${args[@]}"
  else
    why="starting $agent on $machine failed"
    term=$(ssh -n "$target" "cd $dir && ag -d $agent ${args[*]}") || return 1
    ag -a "$machine" "$term" "$agent" "$dir"
  fi
}

move() {
  src=$1 dst=$2 agent=$3 session=$4 dir=$5 hpane=$6 machine=$7 target=$8
  resume
  bk=$HOME/.local/state/teleport/$(date +%Y%m%d-%H%M%S)-$(basename "$dir")
  echo "tp: moving $agent in $dir from $(name "$src") to $(name "$dst")"
  on "$src" herdr pane close "$hpane" >/dev/null 2>&1 || true
  sleep 1
  if ! { sync && go "$dst"; }; then
    tmux display-message -d 8000 "tp: $why, resumed on $(name "$src")"
    go "$src" || echo "tp: resume failed, run: $agent ${args[*]}"
  fi
  exec -l "${SHELL:-bash}"
}

case ${1:-} in
files)
  shift
  files "$@"
  exit
  ;;
move)
  shift
  move "$@"
  ;;
esac

pane=${1:-}
host=$(tmux show -pqv -t "$pane" @ag_host)
term=$(tmux show -pqv -t "$pane" @ag_term)
[ -n "$term" ] || say "no agent started by ag in this pane"
IFS=$'\t' read -r machine target < <(herdr machine list --json | jq -r '[.[] | select(.enabled)] | select(length == 1) | .[0] | [.label, .target] | @tsv') ||
  say "needs exactly one enabled herdr machine"
if [ "$host" = "$HOSTNAME" ]; then
  src=local dst=remote
elif [ "$host" = "$machine" ]; then
  src=remote dst=local
else
  say "unknown host $host"
fi

here=$(on "$src" herdr agent list) || say "herdr on $(name "$src") is unreachable"
there=$(on "$dst" herdr agent list) || say "herdr on $(name "$dst") is unreachable"
IFS=$'\t' read -r agent status dir hpane session < <(jq -r --arg t "$term" '.result.agents[] | select(.terminal_id == $t) | [.agent, .agent_status, .cwd, .pane_id, (.agent_session.value // "")] | @tsv' <<<"$here") ||
  say "agent not found on $(name "$src")"
case $status in idle | done) ;; *) say "$agent is $status, teleport it once it is idle" ;; esac
resume || say "$agent can't be teleported"
[ -n "$session" ] || say "$agent has no session yet"
[[ $dir =~ ^$HOME/[A-Za-z0-9._/-]+$ && $session =~ ^[A-Za-z0-9._/:-]+$ ]] || say "unsupported folder $dir"
on "$src" test ! -e "$dir/.git/index.lock" || say "git is busy in $dir"
jq -e --arg d "$dir" --arg t "$term" 'any(.result.agents[]; .cwd == $d and .terminal_id != $t)' <<<"$here" >/dev/null &&
  say "another agent runs in $dir on $(name "$src")"
jq -e --arg d "$dir" 'any(.result.agents[]; .cwd == $d)' <<<"$there" >/dev/null &&
  say "an agent already runs in $dir on $(name "$dst")"

tmux respawn-pane -k -t "$pane" -c "$dir" "$0" move "$src" "$dst" "$agent" "$session" "$dir" "$hpane" "$machine" "$target"
