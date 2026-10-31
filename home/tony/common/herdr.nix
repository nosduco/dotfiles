{ colors, ... }:
{
  # herdr
  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;
      update.version_check = false;
      theme.custom.accent = colors.accent;
    };
  };
}
