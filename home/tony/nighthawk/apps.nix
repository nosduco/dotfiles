{ pkgs, ... }:
{
  # obsidian
  programs.obsidian.package = pkgs.obsidian.override { commandLineArgs = "--disable-gpu"; };

  # firefox
  programs.firefox.profiles.default.settings."media.hardware-video-decoding.force-enabled" = true;

  # prismlauncher
  programs.prismlauncher.settings = {
    MinMemAlloc = 8000;
    MaxMemAlloc = 16000;
  };

  # voxtype
  programs.voxtype = {
    model.name = "large-v3-turbo";
    settings.whisper.gpu_isolation = true;
  };

  # apps
  home.packages = [
    pkgs.nvtopPackages.nvidia
    pkgs.oversteer
  ];
}
