rule = {
  matches = {
    {
      {
        "device.name", "equals", "alsa_card.pci-0000_00_1f.3"
      },
    },
  },
  apply_properties = {
    ["device.nick"] = "Speakers",
    ["device.description"] = "Speakers",
    ["device.icon-name"] = "audio-speakers-analog-pci",
  },
}

table.insert(alsa_monitor.rules,rule)

