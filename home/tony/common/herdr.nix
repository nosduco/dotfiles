{
  config,
  pkgs,
  lib,
  colors,
  ...
}:
let
  ag = pkgs.writeShellApplication {
    name = "ag";
    runtimeInputs = [
      config.programs.herdr.package
      pkgs.jq
      pkgs.fzf
    ];
    text = ''
      agents() {
        local machine=$1
        shift
        { "$@" workspace list && "$@" agent list; } 2>/dev/null | jq -rs --arg m "$machine" '
          def pad(n): (. + " " * n)[:n];
          ((.[0].result.workspaces? // []) | map({(.workspace_id): .label}) | add // {}) as $ws
          | (.[1].result.agents? // [])[]
          | [$m, .terminal_id, .pane_id,
             ($m | pad(10)) + ($ws[.workspace_id] // .workspace_id | pad(16)) + (.agent | pad(8)) + (.agent_status | pad(9)) + .terminal_title_stripped]
          | @tsv' || true
      }

      if [ $# -eq 0 ]; then
        sel=$(
          {
            agents "$HOSTNAME" herdr
            herdr machine list --json | jq -r '.[] | select(.enabled) | .label' | while read -r m; do
              agents "$m" herdr --machine "$m"
            done
          } | fzf --delimiter='\t' --with-nth=4 --no-sort --prompt='agent> '
        ) || exit 0
        IFS=$'\t' read -r machine term pane _ <<<"$sel"
        if [ "$machine" = "$HOSTNAME" ]; then
          trap 'herdr pane close "$pane" >/dev/null 2>&1' HUP
          herdr terminal attach "$term" || true
        else
          target=$(herdr machine list --json | jq -r --arg m "$machine" '.[] | select(.label == $m) | .target')
          exec ssh -t "$target" herdr terminal attach "$term"
        fi
        exit 0
      fi

      agent=$1
      shift
      dir=$PWD

      ws=$(herdr pane list | jq -r --arg d "$dir" 'first(.result.panes[] | select(.cwd == $d) | .workspace_id) // empty')
      if [ -n "$ws" ]; then
        created=$(herdr tab create --workspace "$ws" --cwd "$dir" --label "$agent" --no-focus)
      else
        created=$(herdr workspace create --cwd "$dir" --label "$(basename "$dir")" --no-focus)
        herdr tab rename "$(jq -r .result.tab.tab_id <<<"$created")" "$agent" >/dev/null
      fi
      pane=$(jq -r .result.root_pane.pane_id <<<"$created")
      term=$(jq -r .result.root_pane.terminal_id <<<"$created")

      herdr pane run "$pane" "exec $(printf '%q ' "$agent" "$@")" >/dev/null
      trap 'herdr pane close "$pane" >/dev/null 2>&1' HUP
      herdr terminal attach "$term" || true
    '';
  };
in
{
  # herdr
  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;
      update.version_check = false;
      theme.custom.accent = colors.accent;
    };
  };
  home.packages = [ ag ];

  # fish
  programs.fish.functions.__herdr_agent_exit = {
    onEvent = "fish_postexec";
    body = ''
      set -q HERDR_PANE_ID; or return
      string match -qr '^(exec )?(claude|codex|pi)\b' -- $argv[1]; and exit
    '';
  };

  # tmux
  programs.tmux.extraConfig = ''
    bind h new-window -S -n herdr ${lib.getExe config.programs.herdr.package}
  '';

  # herdr server
  systemd.user.services.herdr = {
    Unit = {
      Description = "herdr server";
      X-SwitchMethod = "keep-old";
    };
    Service = {
      ExecStart = "${lib.getExe config.programs.herdr.package} server";
      Restart = "on-failure";
    };
  };
}
