{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
  ];

  networking.hostName = "voyager";
  home-manager.users.tony = ../../home/tony/voyager;

}
