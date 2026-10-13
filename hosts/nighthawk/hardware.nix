{ config, pkgs, ... }:
{
  # nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    powerManagement.enable = true;
    nvidiaSettings = false;
    moduleParams = {
      nvidia.NVreg_TemporaryFilePath = "/var/tmp";
      nvidia-modeset.conceal_vrr_caps = 1;
    };
  };

  # data
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/7d83f328-ffbe-4803-bd7b-38237fe79578";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
    ];
  };

  # scratch
  fileSystems."/scratch" = {
    device = "/dev/disk/by-label/scratch";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
    ];
  };

  # cpu
  powerManagement.cpuFreqGovernor = "performance";

  # g923 force feedback
  hardware.new-lg4ff.enable = true;

  # qmk
  hardware.keyboard.qmk.enable = true;

  # ddc
  hardware.i2c.enable = true;
  users.users.tony.extraGroups = [ "i2c" ];
  environment.systemPackages = [ pkgs.ddcutil ];

  # g923 wheel
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c26d", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c26d -M 0f00010142 -C 0x03 -m 01 -r 01"
  '';
}
