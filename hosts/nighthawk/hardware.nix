{ pkgs, ... }:
{
  # cpu
  powerManagement.cpuFreqGovernor = "performance";

  # g923 wheel
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c26d", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c26d -M 0f00010142 -C 0x03 -m 01 -r 01"
  '';
}
