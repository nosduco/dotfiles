{ colors, pkgs, ... }:
{
  # swayosd
  services.swayosd = {
    enable = true;
    stylePath = pkgs.writeText "swayosd.css" ''
      window#osd {
        border-radius: 10px;
        border: 2px solid ${colors.accent};
        background: ${colors.base};
      }
      window#osd #container {
        margin: 16px;
      }
      window#osd image,
      window#osd label {
        color: ${colors.text};
      }
      window#osd progressbar:disabled,
      window#osd image:disabled {
        opacity: 0.5;
      }
      window#osd progressbar,
      window#osd segmentedprogress {
        min-height: 14px;
        border-radius: 10px;
        background: transparent;
        border: none;
      }
      window#osd trough,
      window#osd segment {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: ${colors.surface0};
      }
      window#osd progress,
      window#osd segment.active {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: ${colors.accent};
      }
    '';
  };
}
