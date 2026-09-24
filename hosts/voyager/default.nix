{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
    ../common/optional/gaming.nix
    ../common/optional/printing.nix
    ../common/optional/work.nix
    ./power.nix
  ];

  networking.hostName = "voyager";
  users.users.tony.extraGroups = [ "video" ];
  home-manager.users.tony = ../../home/tony/voyager;

  # location
  services.geoclue2 = {
    enable = true;
    appConfig.gammastep = {
      isAllowed = true;
      isSystem = true;
    };
  };
}
