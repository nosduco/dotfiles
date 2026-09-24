{
  imports = [
    ./theme.nix
    ./apps.nix
    ./cloud.nix
    ./syncthing
    ./dev.nix
    ./work.nix
    ./shell.nix
    ./tide.nix
    ./git.nix
    ./neovim.nix
    ./cli.nix
    ./audio.nix
    ./dunst.nix
    ./files
    ./firefox
    ./gtk
    ./qt.nix
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
