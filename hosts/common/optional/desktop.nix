# Desktop base configuration
{ lib, pkgs, ... }:
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

  # calendar
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  # swayosd
  systemd.packages = [ pkgs.swayosd ];
  systemd.services.swayosd-libinput-backend.wantedBy = [ "graphical.target" ];
  services.dbus.packages = [ pkgs.swayosd ];
  services.udev.packages = [ pkgs.swayosd ];

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

  # virtualization
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
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
      };
    };
    services.openssh.enable = true;
    environment.systemPackages = [ pkgs.kitty ];
    home-manager.users.tony.xdg.configFile."uwsm/env-hyprland".text = lib.mkForce "";
    home-manager.sharedModules = [ { host.vm = true; } ];
  };
}
