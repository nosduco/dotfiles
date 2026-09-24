{
  # nix-ld
  programs.nix-ld.enable = true;

  # docker
  virtualisation.docker.enable = true;
  users.users.tony.extraGroups = [ "docker" ];
}
