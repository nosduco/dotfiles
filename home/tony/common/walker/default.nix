{ colors, pkgs, ... }:
let
  toml = pkgs.formats.toml { };
in
{
  # elephant
  services.elephant = {
    enable = true;
    package = pkgs.elephant.override {
      enabledProviders = [
        "desktopapplications"
        "websearch"
        "providerlist"
        "files"
        "symbols"
        "calc"
        "clipboard"
        "menus"
      ];
    };
  };
  xdg.configFile = {
    "elephant/desktopapplications.toml".source = toml.generate "desktopapplications.toml" {
      show_actions = true;
      only_search_title = true;
    };
    "elephant/websearch.toml".source = toml.generate "websearch.toml" {
      text_prefix = "";
      entries = [
        {
          default = true;
          name = "DuckDuckGo";
          prefix = "ddg";
          url = "https://duckduckgo.com/?q=%TERM%";
        }
        {
          name = "GitHub";
          prefix = "gh";
          url = "https://github.com/search?q=%TERM%";
        }
        {
          name = "Subreddit";
          prefix = "r";
          url = "https://www.reddit.com/r/%TERM%";
        }
        {
          name = "Reddit Search";
          prefix = "rs";
          url = "https://www.reddit.com/search/?q=%TERM%";
        }
      ];
    };
  };

  # walker
  services.walker = {
    enable = true;
    systemd.enable = true;
    settings = {
      columns = {
        symbols = 1;
      };
      force_keyboard_focus = true;
      keybinds = {
        next = [ "ctrl j" ];
        previous = [ "ctrl k" ];
        quick_activate = [
          "shift h"
          "shift j"
          "shift k"
          "shift l"
        ];
      };
      placeholders = {
        default = {
          input = " Search...";
          list = "No Results";
        };
      };
      providers = {
        clipboard = {
          time_format = "%d.%m. - %H:%M";
        };
        default = [
          "desktopapplications"
          "websearch"
        ];
        empty = [
          "desktopapplications"
          "websearch"
        ];
        prefixes = [
          {
            prefix = "/";
            provider = "providerlist";
          }
          {
            prefix = ".";
            provider = "files";
          }
          {
            prefix = ":";
            provider = "symbols";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = "@";
            provider = "websearch";
          }
          {
            prefix = "$";
            provider = "clipboard";
          }
        ];
      };
    };
    theme = {
      name = "custom";
      style = ''
        @define-color selected-text ${colors.accent};
        @define-color text ${colors.text};
        @define-color base ${colors.base};
        @define-color border ${colors.accent};
      ''
      + builtins.readFile ./style.css;
      layout = {
        layout = ./layout.xml;
        item = ./item.xml;
        item_desktopapplications = ./item.xml;
        item_websearch = ./item.xml;
        item_symbols = ./item_symbols.xml;
      };
    };
  };
}
