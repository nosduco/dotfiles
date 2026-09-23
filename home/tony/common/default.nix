{
  imports = [
    ./theme.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./cli.nix
    ./gtk
    ./ghostty.nix
    ./hyprland
    ./waybar
  ];

  home.stateVersion = "26.05";
}
