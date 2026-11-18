{
  imports = [
    ../common
    ../desktop
    ./apps.nix
    ./streamcontroller.nix
    ./hyprland.nix
    ./waybar.nix
    ./updates.nix
  ];

  # ssh
  programs.ssh.settings.voyager.HostName = "100.106.108.12";
}
