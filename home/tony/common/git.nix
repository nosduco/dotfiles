{
  config,
  osConfig,
  lib,
  ...
}:
let
  git = lib.getExe config.programs.git.package;
  dir = osConfig.programs.nh.flake;
  url = "https://github.com/nosduco/dotfiles.git";
  pushUrl = "git@github.com:nosduco/dotfiles.git";
in
{
  # git
  programs.git = {
    enable = true;
    settings = {
      user.name = "tony duco";
      user.email = "td@tonydu.co";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      branch.sort = "-committerdate";
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
      merge.conflictStyle = "zdiff3";
    };
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
      allowedSigners = builtins.readFile ../../../keys/allowed_signers;
    };
  };

  # dotfiles
  home.activation.dotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${dir} ]; then
      run ${git} clone ${url} ${dir} \
        && run ${git} -C ${dir} remote set-url --push origin ${pushUrl} \
        || warnEcho "could not clone ${url} to ${dir}, retrying on next switch"
    fi
  '';

  # delta
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # gh
  programs.gh = {
    enable = true;
    settings.aliases.co = "pr checkout";
  };

  # gh-dash
  programs.gh-dash.enable = true;

  programs.fish.shellAliases = {
    gd = "gh dash";
    ci = ''gh run watch "$(gh run list --limit 1 --json databaseId --jq '.[0].databaseId')" && notify-send "GitHub CI" "Workflow has finished"'';
  };
}
