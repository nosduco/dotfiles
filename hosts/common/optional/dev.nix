{
  # nix-ld
  programs.nix-ld.enable = true;

  # docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
  users.users.tony.extraGroups = [ "docker" ];
}
