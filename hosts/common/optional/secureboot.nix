{
  config,
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

  # comin boot entry
  services.comin.postDeploymentCommand = pkgs.writeShellScript "comin-boot-entry" ''
    [ "$COMIN_STATUS" = done ] || exit 0
    system=$(readlink -f /nix/var/nix/profiles/system-profiles/comin)
    [ "$system" = "$(readlink -f /run/current-system)" ] || exit 0
    ${lib.getExe' config.nix.package "nix-env"} -p /nix/var/nix/profiles/system --set "$system" \
      && "$system/bin/switch-to-configuration" boot
  '';
}
