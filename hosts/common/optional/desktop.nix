# Desktop base configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  keychron = pkgs.writeTextDir "lib/udev/rules.d/70-keychron.rules" ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="3434", TAG+="uaccess"
  '';
  livesync = {
    couchDB_URI = "https://obsidian.tuxcloud.xyz";
    couchDB_DBNAME = "obsidian";
    isConfigured = true;
    liveSync = true;
    syncOnStart = true;
    syncOnSave = true;
    syncOnFileOpen = true;
    encrypt = true;
    E2EEAlgorithm = "v2";
    usePathObfuscation = true;
    encryptInternalMetadata = true;
    idDerivationVersion = 0;
    handleFilenameCaseSensitive = false;
    useDynamicIterationCount = false;
    hashAlg = "xxhash64";
    chunkSplitterVersion = "v3-rabin-karp";
    customChunkSize = 60;
    minimumChunkSize = 20;
    enableCompression = false;
    useEden = false;
    usePluginSync = true;
    usePluginSyncV2 = true;
    deviceAndVaultName = config.networking.hostName;
  };
in
{
  # hyprland
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # hyprlock
  programs.hyprlock.enable = true;

  # portals
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  # files
  services.gvfs.enable = true;

  # ledger
  hardware.ledger.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;

  # calendar
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  # swayosd
  systemd.packages = [ pkgs.swayosd ];
  systemd.services.swayosd-libinput-backend.wantedBy = [ "graphical.target" ];
  services.dbus.packages = [ pkgs.swayosd ];

  # udev
  services.udev.packages = [
    pkgs.swayosd
    keychron
  ];

  # keyring
  services.gnome.gnome-keyring.enable = true;
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";
  };
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  # greeter
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = "${lib.getExe' pkgs.tuigreet "tuigreet"} --time --remember --cmd 'uwsm start -e -D Hyprland hyprland.desktop'";
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # obsidian livesync
  sops.templates."obsidian-livesync.json" = {
    owner = "tony";
    content = builtins.toJSON (
      livesync
      // {
        couchDB_USER = config.sops.placeholder.livesync-user;
        couchDB_PASSWORD = config.sops.placeholder.livesync-password;
        passphrase = config.sops.placeholder.livesync-passphrase;
      }
    );
  };

  # virtualization
  virtualisation.vmVariant = {
    sops.templates."obsidian-livesync.json".content = lib.mkForce (
      builtins.toJSON (
        livesync
        // {
          couchDB_URI = "http://127.0.0.1:9";
          couchDB_USER = "vm";
          couchDB_PASSWORD = "vm";
          passphrase = "vm";
        }
      )
    );
    virtualisation = {
      memorySize = 4096;
      diskSize = 8192;
      cores = 4;
      qemu.options = [ "-vga none -device virtio-gpu-pci" ];
      forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
      ];
      sharedDirectories.dotfiles = {
        source = "/home/tony/nixos-config";
        target = "/home/tony/.dotfiles";
        writable = true;
      };
    };
    services.openssh = {
      enable = true;
      openFirewall = lib.mkForce true;
      settings.PasswordAuthentication = lib.mkForce true;
    };
    services.comin = {
      hostname = "vmtest";
      remotes = lib.mkForce [
        {
          name = "vmtest";
          url = "/var/lib/comin-vmtest";
          branches.main.name = "main";
          poller.period = 5;
        }
      ];
      sshAllowedSignersPath = lib.mkForce "/var/lib/comin-vmtest-signers";
    };
    environment.systemPackages = [ pkgs.kitty ];
    home-manager.users.tony.xdg.configFile."uwsm/env-hyprland".text = lib.mkForce "";
    home-manager.sharedModules = [
      {
        host.vm = true;
        services.syncthing.settings.devices.tux-hub.paused = true;
        systemd.user.timers.kopia.Install.WantedBy = lib.mkForce [ ];
      }
    ];
  };
}
