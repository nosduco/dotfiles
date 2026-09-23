{
  imports = [
    ./theme.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./cli.nix
    ./audio.nix
    ./dunst.nix
    ./files
    ./gtk
    ./host.nix
    ./ghostty.nix
    ./swayosd.nix
    ./xdg.nix
    ./hyprland
    ./waybar
    ./walker
  ];

  home.stateVersion = "26.05";
}
