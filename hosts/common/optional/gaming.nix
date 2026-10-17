{ pkgs, ... }:
{
  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    extraPackages = [ pkgs.mangohud ];
    package = pkgs.steam.override { extraEnv.MANGOHUD = true; };
  };

  # gamescope
  programs.gamescope.enable = true;

  # split lock
  boot.kernel.sysctl."kernel.split_lock_mitigate" = 0;
}
