# Desktop base configuration
{ lib, pkgs, ... }:
{
  # hyprland
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

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
      forwardPorts = [ { from = "host"; host.port = 2222; guest.port = 22; } ];
    };
    services.openssh.enable = true;
    environment.systemPackages = [ pkgs.kitty ];
  };
}
