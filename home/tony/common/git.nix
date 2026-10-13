{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  git = lib.getExe config.programs.git.package;
  dir = osConfig.programs.nh.flake;
  remote = builtins.head osConfig.services.comin.remotes;
  branch = remote.branches.main.name;
  pushUrl = builtins.replaceStrings [ "https://github.com/" ] [ "git@github.com:" ] remote.url;
in
{
  # git
  programs.git = {
    enable = true;
    settings = {
      user.name = "tony duco";
      user.email = "td@tonydu.co";
      init.defaultBranch = "main";
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
      run ${git} clone -b ${branch} ${remote.url} ${dir} \
        && run ${git} -C ${dir} remote set-url --push origin ${pushUrl} \
        || warnEcho "could not clone ${remote.url} to ${dir}, retrying on next switch"
    elif [ "$(${git} -C ${dir} branch --show-current)" = ${branch} ]; then
      run env GIT_TERMINAL_PROMPT=0 ${pkgs.coreutils}/bin/timeout 30 ${git} -C ${dir} pull --quiet --ff-only \
        || warnEcho "could not fast-forward ${dir}, pull it by hand"
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
