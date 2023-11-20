rule = {
  matches = {
    {
      {
        "node.name", "equals", "alsa_output.usb-Schiit_Audio_Schiit_Modi_3E-00.analog-stereo"
      },
    },
  },
  apply_properties = {
    ["device.nick"] = "Headphones",
    ["device.description"] = "Headphones",
    ["device.form-factor"] = "headphones",
    ["node.nick"] = "Headphones",
    ["node.description"] = "Headphones",
  },
}

table.insert(alsa_monitor.rules,rule)

