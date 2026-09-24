{ pkgs, ... }:
{
  # obsidian
  programs.obsidian.enable = true;

  # apps
  home.packages = with pkgs; [
    gnome-calendar
    gnome-disk-utility
    mixxx
    multiviewer-for-f1
    planify
    redact
    video-trimmer
  ];
}
