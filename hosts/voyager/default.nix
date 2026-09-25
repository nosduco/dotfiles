{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
    ../common/optional/dev.nix
    ../common/optional/gaming.nix
    ../common/optional/network.nix
    ../common/optional/printing.nix
    ../common/optional/work.nix
    ./network.nix
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

  # network applet
  programs.nm-applet.enable = true;

  # keyboard
  services.evremap = {
    enable = true;
    settings = {
      device_name = "AT Translated Set 2 keyboard";
      remap = [
        {
          input = [ "KEY_CAPSLOCK" ];
          output = [ "KEY_LEFTCTRL" ];
        }
      ];
    };
  };

  # firmware
  services.fwupd.enable = true;
  hardware.system76.firmware-daemon.enable = true;

  # switch rcm
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idProduct}=="7321", TAG+="uaccess"
  '';
}
