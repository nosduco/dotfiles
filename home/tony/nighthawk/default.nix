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

  # backup
  backup.sources = [
    ".codex"
    ".kube"
    ".local/share/fish/fish_history"
    ".local/share/keyrings"
    ".mixxx"
    ".pi"
  ];

  # ssh
  programs.ssh.settings.voyager.HostName = "100.106.108.12";
}
