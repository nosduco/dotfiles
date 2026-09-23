{
  monitor,
  brightness ? null,
}:
{
  general.grace = 3;
  background = [
    (
      {
        path = "screenshot";
        color = "$base";
        blur_passes = 2;
        blur_size = 7;
        noise = 0.0117;
        contrast = 0.8172;
      }
      // (if brightness == null then { } else { inherit brightness; })
    )
  ];
  input-field = [
    {
      inherit monitor;
      size = "250, 50";
      outline_thickness = 2;
      inner_color = "rgba(0, 0, 0, 0.0)";
      dots_size = 0.33;
      dots_spacing = 0.15;
      dots_center = false;
      dots_rounding = -1;
      placeholder_text = "<i>Be careful...</i>";
      fail_text = "<i>WRONG! GTFO!<b>($ATTEMPTS)</b></i>";
      outer_color = "$accent $yellow 45deg";
      check_color = "$sky $sapphire 120deg";
      fail_color = "$red $maroon 40deg";
      font_color = "rgb(143, 143, 143)";
      fade_on_empty = true;
      fade_timeout = 4000;
      rounding = 10;
      position = "0, -10";
      halign = "center";
      valign = "center";
    }
  ];
  label = [
    {
      inherit monitor;
      text = "tony, is that you?";
      color = "$text";
      font_size = 25;
      font_family = "Noto Sans";
      position = "0, 80";
      halign = "center";
      valign = "center";
    }
  ];
}
