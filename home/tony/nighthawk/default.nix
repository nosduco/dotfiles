{
  imports = [
    ../common
    ./apps.nix
    ./streamcontroller.nix
    ./hyprland.nix
    ./waybar.nix
    ./updates.nix
  ];

  # backup
  backup.sources = [ "backups" ];

  # ssh
  programs.ssh.settings.voyager.HostName = "100.106.108.12";
}
