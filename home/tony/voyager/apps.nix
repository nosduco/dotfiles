{ pkgs, ... }:
{
  # nvtop
  home.packages = [ pkgs.nvtopPackages.amd ];

  # voxtype
  programs.voxtype.model.name = "base.en";
}
