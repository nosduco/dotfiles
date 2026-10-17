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

  # ntsync
  boot.kernelModules = [ "ntsync" ];

  # steamos sysctls
  boot.kernel.sysctl = {
    "kernel.split_lock_mitigate" = 0;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.ipv4.tcp_fin_timeout" = 5;
    "vm.max_map_count" = 2147483642;
  };
}
