rule = {
  matches = {
    {
      {
        "node.name", "equals", "alsa_output.pci-0000_00_1f.3.analog-stereo"
      },
    },
  },
  apply_properties = {
    ["device.nick"] = "Speakers",
    ["device.description"] = "Speakers",
    ["device.icon-name"] = "audio-speakers-analog-pci",
    ["node.nick"] = "Speakers",
    ["node.description"] = "Speakers",
    ["node.icon-name"] = "audio-speakers-analog-pci",
  },
}

table.insert(alsa_monitor.rules,rule)

