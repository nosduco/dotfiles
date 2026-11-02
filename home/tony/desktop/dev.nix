{ pkgs, ... }:
{
  # android
  home.packages = [ pkgs.android-studio ];

  # clipboard
  services.wl-clip-persist = {
    enable = true;
    clipboardType = "regular";
  };

  # herdr server
  systemd.user.services.herdr = {
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
