{
  imports = [
    ./theme.nix
    ./apps.nix
    ./work.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./cli.nix
    ./audio.nix
    ./dunst.nix
    ./files
    ./firefox
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
