{ pkgs, ... }:
{
  # steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # gamescope
  programs.gamescope.enable = true;

  # gamemode
  programs.gamemode = {
    enable = true;
    settings = {
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'Gamemode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'Gamemode ended'";
      };
    };
  };
  users.users.tony.extraGroups = [ "gamemode" ];
}
