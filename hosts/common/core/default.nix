{ pkgs, ... }: {
  # state
  system.stateVersion = "26.05";

  # core imports
  imports = [ ./home-manager.nix ];

  # platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # boot
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
  };

  # users
  users.users.tony = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "video"
    ];
    initialPassword = "test";
    shell = pkgs.fish;
  };

  # locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # programs
  programs.fish.enable = true;
}
