{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  # catppuccin
  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = "peach";
    cursors.enable = true;
  };

}
