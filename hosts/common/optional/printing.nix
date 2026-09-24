{ pkgs, ... }:
{
  # printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  programs.system-config-printer.enable = true;

  # discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
