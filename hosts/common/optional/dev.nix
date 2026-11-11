{ config, lib, ... }:
{
  # nix-ld
  programs.nix-ld.enable = true;

  # docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
  users.users.tony.extraGroups = lib.mkIf config.virtualisation.docker.enable [ "docker" ];
}
