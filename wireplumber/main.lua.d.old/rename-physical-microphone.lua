rule = {
  matches = {
    {
      {
        "device.name", "equals", "alsa_card.usb-Audio_Technica_Corp_ATR2500x-USB_Microphone-00"
      },
    },
  },
  apply_properties = {
    ["device.nick"] = "Microphone",
    ["device.description"] = "Microphone",
    ["node.nick"] = "Microphone",
    ["node.description"] = "Microphone",
  },
}

table.insert(alsa_monitor.rules,rule)

