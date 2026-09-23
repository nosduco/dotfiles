{
  imports = [
    ./theme.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./cli.nix
    ./dunst.nix
    ./gtk
    ./ghostty.nix
    ./swayosd.nix
    ./xdg.nix
    ./hyprland
    ./waybar
  ];

  home.stateVersion = "26.05";
}
