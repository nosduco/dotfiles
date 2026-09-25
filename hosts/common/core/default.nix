{ inputs, pkgs, ... }: {
  # state
  system.stateVersion = "26.05";
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # core imports
  imports = [
    ./home-manager.nix
    ./fonts.nix
    ./sops.nix
    ./upgrade.nix
  ];

  # platform
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  # nix
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # boot
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
  };

  # hardware
  hardware.cpu.amd.updateMicrocode = true;
  zramSwap.enable = true;

  # users
  users.users.tony = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
    shell = pkgs.fish;
  };

  # locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # programs
  programs.fish.enable = true;
  programs.nh = {
    enable = true;
    flake = "/home/tony/.dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  # environment
  environment.localBinInPath = true;

  # ssh
  programs.ssh.knownHosts."tux-pve.nosnet".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg4b4qSd+oh1pUDCaAqsXGDs8/Fd1ByWUfRKR78jhh7";
}
