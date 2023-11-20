rule = {
  matches = {
    {
      {
        "node.name", "equals", "alsa_input.usb-046d_Logitech_StreamCam_B3148235-02.analog-stereo"
      },
    },
  },
  apply_properties = {
    ["node.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules,rule)

