{
  colors,
  inputs,
  pkgs,
  ...
}:
let
  voxtype = inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.voxtype.homeManagerModules.default ];

  # voxtype
  programs.voxtype = {
    enable = true;
    package = voxtype.vulkan;
    service.enable = true;
    settings.output = {
      notification.on_transcription = false;
      pre_output_command = "hyprctl dispatch 'hl.dsp.submap(\"voxtype_suppress\")'";
      post_output_command = "hyprctl dispatch 'hl.dsp.submap(\"reset\")'";
    };
    settings.osd = {
      position = "top-center";
      top_margin = 0.0;
    };
  };

  # osd
  home.packages = [ voxtype.osd-gtk4 ];
  xdg.configFile."omarchy/current/theme/colors.toml".source =
    (pkgs.formats.toml { }).generate "voxtype-colors" {
      background = colors.base;
      foreground = colors.text;
      accent = colors.accent;
      color1 = colors.red;
      color2 = colors.green;
      color3 = colors.yellow;
    };
}
