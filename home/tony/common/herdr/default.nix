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
    text = builtins.readFile ./ag.sh;
  };
  tp = pkgs.writeShellApplication {
    name = "tp";
    runtimeInputs = [
      config.programs.herdr.package
      pkgs.jq
      pkgs.rsync
      ag
    ];
    text = builtins.readFile ./tp.sh;
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
  home.packages = [
    ag
    tp
  ];

  # herdr integrations
  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p $HOME/.codex $HOME/.pi/agent
    for agent in claude codex pi; do
      run ${lib.getExe config.programs.herdr.package} integration install $agent
    done
  '';

  # fish
  programs.fish.functions =
    lib.mapAttrs
      (agent: starts: ''
        if status is-interactive; and not set -q HERDR_PANE_ID; and string match -qr '^(${starts})?$' -- "$argv"
          ag ${agent} $argv
        else
          command ${agent} $argv
        end
      '')
      {
        claude = ''-c|--continue|(-r|--resume)( \S+)?'';
        codex = ''resume( \S+)?'';
        pi = ''-c|--continue|-r|--resume|--session \S+'';
      }
    // {
      __herdr_agent_exit = {
        onEvent = "fish_postexec";
        body = ''
          set -q HERDR_PANE_ID; or return
          string match -qr '^(exec )?(claude|codex|pi)\b' -- $argv[1]; and exit
        '';
      };
    };

  # tmux
  programs.tmux.extraConfig = ''
    bind h new-window -S -n herdr ${lib.getExe config.programs.herdr.package}
    bind t run-shell -b "${lib.getExe tp} '#{pane_id}'"
    set -g pane-border-format "#{?@ag_host, #{?@ag_target,#[fg=${colors.green}],#[fg=${
      colors.${config.tide.contextColor}
    }]}#{@ag_host}#[default] #{@ag_agent} #{@ag_dir} ,}"
    set -ga status-left "#{?#(${lib.getExe ag} -c),#[fg=${colors.yellow}] #(${lib.getExe ag} -c) detached ,}"
  '';

  # teleport backups
  systemd.user.tmpfiles.rules = [ "d %h/.local/state/teleport - - - 14d" ];

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
