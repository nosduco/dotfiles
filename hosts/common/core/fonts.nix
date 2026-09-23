{ pkgs, ... }:
{
  # fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      material-design-icons
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      monospace = [ "JetBrains Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
