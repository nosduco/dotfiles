{ ... }:
{
  # ghostty
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrains Mono";
      font-size = 10;
      cursor-style = "underline";
      mouse-hide-while-typing = true;
      background-opacity = "0.7";
      background-blur = true;
      command = "tmux new-session";
      window-decoration = false;
      window-padding-x = 8;
      window-padding-y = 4;
      app-notifications = "no-clipboard-copy";
      shell-integration = "fish";
      shell-integration-features = "no-cursor";
      custom-shader = "${../../../config/ghostty/shaders/cursor_smear_fade_gsls.gsls}";
    };
  };
}
