{ config, inputs, pkgs, ... }: {
  # state
  system.stateVersion = "26.05";
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # core imports
  imports = [
    inputs.disko.nixosModules.disko
    ./home-manager.nix
    ./fonts.nix
    ./sops.nix
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
    substituters = [ "https://nix.tuxcloud.xyz/dotfiles" ];
    trusted-public-keys = [ "dotfiles:k0K3s3Ow0wzObZyw4YiBK6+SFacti0CSfowKkN4E0Z8=" ];
    connect-timeout = 5;
    fallback = true;
  };

  # boot
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
  };

  # hardware
  hardware.cpu.amd.updateMicrocode = true;
  zramSwap.enable = true;
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
  };
  services.fwupd.enable = true;

  # btrfs
  services.btrfs.autoScrub.enable = true;
  systemd.services."btrfs-scrub@".unitConfig.OnFailure = [ "btrfs-scrub-failed.service" ];
  systemd.services.btrfs-scrub-failed = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${config.systemd.package}/bin/systemd-run --user --machine=tony@ --quiet \
        ${pkgs.libnotify}/bin/notify-send -u critical -a System System "btrfs scrub found errors. journalctl -u 'btrfs-scrub@*'"
    '';
  };

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
