{ pkgs, ... }:
{
  # obsidian
  programs.obsidian.package = pkgs.obsidian.override { commandLineArgs = "--disable-gpu"; };
}
