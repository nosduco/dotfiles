{ pkgs, ... }:
{
  # android
  home.packages = [ pkgs.android-studio ];

  # clipboard
  services.wl-clip-persist = {
    enable = true;
    clipboardType = "regular";
  };
}
