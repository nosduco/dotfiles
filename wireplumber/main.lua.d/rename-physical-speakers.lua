rule = {
  matches = {
    {
      {
        "node.name", "equals", "alsa_output.usb-Generic_USB_Audio-00.HiFi__hw_Audio__sink"
      },
    },
  },
  apply_properties = {
    ["device.nick"] = "Speakers",
    ["device.description"] = "Speakers",
    ["device.icon-name"] = "audio-speakers-analog-pci",
    ["device.form-factor"] = "speaker",
    ["node.nick"] = "Speakers",
    ["node.description"] = "Speakers",
    ["node.icon-name"] = "audio-speakers-analog-pci",
  },
}

table.insert(alsa_monitor.rules,rule)

