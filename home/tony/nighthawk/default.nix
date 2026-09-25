{
  imports = [
    ../common
    ./apps.nix
    ./streamcontroller.nix
    ./hyprland.nix
    ./waybar.nix
  ];

  # backup
  backup.sources = [ "backups" ];
}
