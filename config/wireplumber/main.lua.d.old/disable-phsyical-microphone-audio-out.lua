rule = {
  matches = {
    {
      {
        "node.name", "equals", "alsa_output.usb-Audio_Technica_Corp_ATR2500x-USB_Microphone-00.iec958-stereo"
      },
    },
  },
  apply_properties = {
    ["node.disabled"] = true,
    ["device.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules,rule)

