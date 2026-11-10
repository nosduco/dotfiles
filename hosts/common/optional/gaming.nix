{ inputs, pkgs, ... }:
{
  # millennium
  nixpkgs.overlays = [ inputs.millennium.overlays.default ];

  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    extraPackages = [ pkgs.mangohud ];
    package =
      if pkgs ? steamWithMillennium then
        throw "nixos-unstable has steamWithMillennium: drop the millennium input and overlay"
      else
        pkgs.millennium-steam.override { extraEnv.MANGOHUD = true; };
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
