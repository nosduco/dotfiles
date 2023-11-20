rule = {
  matches = {
    {
      {
        "device.name", "equals", "alsa_card.usb-Generic_USB_Audio-00"
      },
    },
  },
  apply_properties = {
    ["device.icon-name"] = "audio-speakers-analog-pci",
    ["device.form-factor"] = "speaker",
  },
}

table.insert(alsa_monitor.rules,rule)

