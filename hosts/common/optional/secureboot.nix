{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  # secure boot
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.editor = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };
  environment.systemPackages = [ pkgs.sbctl ];
}
