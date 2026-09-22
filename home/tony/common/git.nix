{ ... }:
{
  # git
  programs.git = {
    enable = true;
    settings = {
      user.name = "tony duco";
      user.email = "td@tonydu.co";
      init.defaultBranch = "main";
    };
  };

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
