{
  colors,
  config,
  pkgs,
  ...
}:
let
  # nixpkgs builds no OSD frontend; add the gtk4 one next to the voxtype-osd launcher.
  voxtype = pkgs.voxtype-vulkan.overrideAttrs (old: {
    cargoBuildFeatures = old.cargoBuildFeatures ++ [ "osd-gtk4" ];
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.wrapGAppsHook4 ];
    buildInputs = old.buildInputs ++ [
      pkgs.gtk4
      pkgs.gtk4-layer-shell
    ];
    dontWrapGApps = true;
    postFixup = (old.postFixup or "") + ''
      wrapGApp $out/bin/voxtype-osd-gtk4
    '';
  });
in
{
  # voxtype
  services.voxtype = {
    enable = true;
    package = voxtype;
    # The module's PATH has no sh, which runs the output hooks, and no hyprctl.
    environment.PATH = "/run/wrappers/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin";
    # Upstream's default.toml sets these two away from the built-in defaults.
    settings.hotkey.enabled = false;
    settings.output = {
      paste_keys = "shift+insert";
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
