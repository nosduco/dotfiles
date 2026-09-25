{
  colors,
  config,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
  claude-desktop-base = inputs.claude-desktop.packages.${system}.default.override {
    claude-code = pkgs.claude-code;
    qemu = null;
    OVMF = null;
    virtiofsd = null;
  };
  claude-desktop = pkgs.symlinkJoin {
    name = "claude-desktop";
    paths = [ claude-desktop-base ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude-desktop \
        --set CHROME_DEVEL_SANDBOX ${claude-desktop-base}/lib/claude-desktop/chrome-sandbox
    '';
  };
  accent = colors.hsl.accent;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  # obsidian
  programs.obsidian.enable = true;

  # vesktop
  programs.vesktop = {
    enable = true;
    settings = {
      minimizeToTray = true;
      arRPC = true;
      splashColor = colors.text;
      splashBackground = colors.crust;
      spellCheckLanguages = [
        "en-US"
        "en"
      ];
    };
    vencord.settings.plugins.FakeNitro.enabled = true;
  };

  # element
  programs.element-desktop = {
    enable = true;
    package = pkgs.element-desktop.override { commandLineArgs = "--password-store=gnome-libsecret"; };
    settings.show_labs_settings = true;
  };

  # prismlauncher
  programs.prismlauncher = {
    enable = true;
    settings = {
      ApplicationTheme = "system";
      Language = "en_US";
      IconTheme = "flat";
      BackgroundCat = "rory-flat";
    };
  };

  # media
  programs.mpv.enable = true;

  # spotify
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = config.catppuccin.flavor;
    experimentalFeatures = true;
  };

  # office
  programs.libreoffice.enable = true;

  # chromium
  programs.chromium.enable = true;

  # claude desktop
  xdg.configFile = {
    "Claude/themes.d/catppuccin-mocha-peach.json".text = builtins.toJSON {
      extends = "catppuccin-mocha";
      dark = {
        "--accent-brand" = accent;
        "--accent-000" = accent;
        "--accent-100" = accent;
        "--accent-200" = accent;
        "--accent-900" = colors.hsl.surface1;
        "--brand-000" = accent;
        "--brand-100" = accent;
        "--brand-200" = accent;
        "--claude-accent-clay" = colors.accent;
      };
    };
    "Claude/claude-desktop-extra.jsonc" = {
      force = true;
      text = builtins.toJSON { activeTheme = "catppuccin-mocha-peach"; };
    };
  };

  # apps
  home.packages = [
    claude-desktop
    inputs.helium.packages.${system}.helium-widevine
  ]
  ++ (with pkgs; [
    gnome-calendar
    gnome-disk-utility
    ledger-live-desktop
    loupe
    mixxx
    multiviewer-for-f1
    planify
    redact
    video-trimmer
  ]);
}
