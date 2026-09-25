let
  disable = name: {
    matches = [ { "node.name" = name; } ];
    actions.update-props."node.disabled" = true;
  };
  rename = name: label: {
    matches = [ { "node.name" = name; } ];
    actions.update-props = {
      "node.nick" = label;
      "node.description" = label;
    };
  };
in
{
  # latency
  services.pipewire.extraConfig.pipewire."10-low-latency"."context.properties" = {
    "default.clock.rate" = 48000;
    "default.clock.allowed-rates" = [
      44100
      48000
      88200
      96000
    ];
    "default.clock.quantum" = 256;
    "default.clock.min-quantum" = 128;
    "default.clock.max-quantum" = 1024;
  };

  # devices
  services.pipewire.wireplumber.extraConfig."50-device-renames"."monitor.alsa.rules" = [
    (disable "~alsa_output.pci-0000_01_00.1.*")
    (disable "~alsa_*.pci-0000_7a_00.1.*")
    (disable "alsa_input.pci-0000_7a_00.6.analog-stereo")
    (rename "alsa_output.usb-Schiit_Audio_Schiit_Modi_3E-00.analog-stereo" "Headphones")
    (rename "alsa_output.pci-0000_7a_00.6.analog-stereo" "Speakers")
    (rename "alsa_input.usb-046d_Logitech_StreamCam_B3148235-02.analog-stereo" "Webcam")
  ];
}
