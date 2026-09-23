{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
  ];

  networking.hostName = "voyager";
  users.users.tony.extraGroups = [ "video" ];
  home-manager.users.tony = ../../home/tony/voyager;

}
