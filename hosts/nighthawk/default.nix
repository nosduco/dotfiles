{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
  ];

  networking.hostName = "nighthawk";
  home-manager.users.tony = ../../home/tony/nighthawk.nix;
}
