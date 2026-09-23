{ pkgs, ... }:
{
  # fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      inter
      noto-fonts-color-emoji
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      material-design-icons
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter Variable" ];
      serif = [ "Noto Serif" ];
      monospace = [ "JetBrains Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
