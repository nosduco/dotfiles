rule = {
  matches = {
    {
      {
        "device.name", "equals", "alsa_card.usb-Schiit_Audio_Schiit_Modi_3E-00"
      },
    },
  },
  apply_properties = {
    ["device.nick"] = "Headphones",
    ["device.description"] = "Headphones",
    ["node.nick"] = "Headphones",
    ["node.description"] = "Headphones",
  },
}

table.insert(alsa_monitor.rules,rule)

