{
  config,
  osConfig,
  lib,
  ...
}:
let
  git = lib.getExe config.programs.git.package;
  dir = osConfig.programs.nh.flake;
  remote = builtins.head osConfig.services.comin.remotes;
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
  home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${dir} ]; then
      run ${git} clone -b ${remote.branches.main.name} ${remote.url} ${dir} \
        && run ${git} -C ${dir} remote set-url --push origin ${pushUrl} \
        || warnEcho "could not clone ${remote.url} to ${dir}, retrying on next switch"
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
