rule = {
  matches = {
    {
      {
        "node.name", "equals", "alsa_input.pci-0000_00_1f.3.analog-stereo"
      },
    },
  },
  apply_properties = {
    ["node.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules,rule)

