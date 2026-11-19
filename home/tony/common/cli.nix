{
  colors,
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # bat
  programs.bat.enable = true;
  programs.fish.shellAbbrs.cat = "bat";

  # btop
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      proc_sorting = "threads";
    };
  };
  programs.fish.shellAliases.top = "btop";
  programs.fish.shellAliases.htop = "btop";

  # fastfetch
  programs.fastfetch.enable = true;

  # ripgrep
  programs.ripgrep.enable = true;
  programs.fish.shellAbbrs.grep = "rg";

  # jq
  programs.jq.enable = true;

  # trash
  programs.fish.shellAbbrs.rm = "trash";

  # archives
  programs.fish.shellAliases.ex = "ouch decompress";

  # packages
  home.packages = with pkgs; [
    age
    bitwarden-cli
    bluetui
    gws
    ouch
    sops
    trash-cli
  ];

  # yazi
  catppuccin.yazi.enable = false;
  programs.yazi = {
    enable = true;
    shellWrapperName = "fs";
    extraPackages = with pkgs; [
      file
      libnotify
    ];
    plugins.piper = pkgs.yaziPlugins.piper;
    settings.plugin.prepend_previewers = [
      {
        mime = "text/*";
        run = ''piper -- ${lib.getExe config.programs.bat.package} --style=numbers --color=always "$1"'';
      }
    ];
    settings.mgr = {
      show_hidden = true;
      sort_by = "mtime";
      sort_reverse = true;
      sort_dir_first = false;
    };
    keymap.mgr.prepend_keymap = [
      {
        on = "Y";
        run = ''shell -- case "$(file -b --mime-type %h)" in image/*) wl-copy --type "$(file -b --mime-type %h)" < %h ;; *) echo -n "file://%h" | wl-copy -t text/uri-list ;; esac && notify-send -t 2000 "Yazi" "Copied to clipboard"'';
        desc = "Copy file to system clipboard";
      }
      {
        on = [
          "g"
          "t"
        ];
        run = "cd ~/cloud";
        desc = "Goto tuxcloud mount";
      }
    ];
    flavors.catppuccin-mocha = "${inputs.yazi-flavors}/catppuccin-mocha.yazi";
    theme = {
      flavor.dark = "catppuccin-mocha";
      indicator = {
        current = {
          fg = colors.base;
          bg = colors.accent;
        };
        preview = {
          fg = colors.base;
          bg = colors.accent;
        };
        padding = {
          open = "█";
          close = "█";
        };
      };
      tabs = {
        active = {
          fg = colors.base;
          bg = colors.accent;
          bold = true;
        };
        inactive = {
          fg = colors.accent;
          bg = colors.surface0;
        };
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };
      mode = {
        normal_main = {
          fg = colors.base;
          bg = colors.accent;
          bold = true;
        };
        normal_alt = {
          fg = colors.accent;
          bg = colors.surface0;
        };
      };
      filetype.rules = [
        {
          mime = "image/*";
          fg = colors.teal;
        }
        {
          mime = "{audio,video}/*";
          fg = colors.yellow;
        }
        {
          mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          fg = colors.pink;
        }
        {
          mime = "application/{pdf,doc,rtf}";
          fg = colors.green;
        }
        {
          mime = "vfs/{absent,stale}";
          fg = colors.overlay2;
        }
        {
          url = "*";
          fg = colors.text;
        }
        {
          url = "*/";
          fg = colors.accent;
        }
      ];
      icon.prepend_conds = [
        {
          "if" = "dir";
          text = "";
          fg = colors.accent;
        }
      ];
      spot = {
        border.fg = colors.accent;
        title.fg = colors.accent;
        tbl_cell = {
          fg = colors.accent;
          reversed = true;
        };
        tbl_col.bold = true;
      };
      status = {
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };
      };
    };
  };
}
