{ inputs, pkgs, ... }:
{
  # bat
  programs.bat.enable = true;
  programs.fish.shellAliases.cat = "bat";

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

  # ripgrep
  programs.ripgrep.enable = true;
  programs.fish.shellAliases.grep = "rg --color=always";

  # jq
  programs.jq.enable = true;

  # trash
  home.packages = [ pkgs.trash-cli ];
  programs.fish.shellAliases.rm = "trash";

  # yazi
  catppuccin.yazi.enable = false;
  programs.yazi = {
    enable = true;
    extraPackages = with pkgs; [
      file
      libnotify
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
        on = [ "g" "t" ];
        run = "cd ~/cloud";
        desc = "Goto tuxcloud mount";
      }
    ];
    flavors.catppuccin-mocha = "${inputs.yazi-flavors}/catppuccin-mocha.yazi";
    theme = {
      flavor.dark = "catppuccin-mocha";
      indicator = {
        current = { fg = "#1e1e2e"; bg = "#fab387"; };
        preview = { fg = "#1e1e2e"; bg = "#fab387"; };
        padding = { open = "█"; close = "█"; };
      };
      tabs = {
        active = { fg = "#1e1e2e"; bg = "#fab387"; bold = true; };
        inactive = { fg = "#fab387"; bg = "#313244"; };
        sep_inner = { open = ""; close = ""; };
        sep_outer = { open = ""; close = ""; };
      };
      mode = {
        normal_main = { fg = "#1e1e2e"; bg = "#fab387"; bold = true; };
        normal_alt = { fg = "#fab387"; bg = "#313244"; };
      };
      filetype.rules = [
        { mime = "image/*"; fg = "#94e2d5"; }
        { mime = "{audio,video}/*"; fg = "#f9e2af"; }
        { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}"; fg = "#f5c2e7"; }
        { mime = "application/{pdf,doc,rtf}"; fg = "#a6e3a1"; }
        { mime = "vfs/{absent,stale}"; fg = "#9399b2"; }
        { url = "*"; fg = "#cdd6f4"; }
        { url = "*/"; fg = "#fab387"; }
      ];
      icon.prepend_conds = [
        { "if" = "dir"; text = ""; fg = "#fab387"; }
      ];
      status = {
        sep_left = { open = ""; close = ""; };
        sep_right = { open = ""; close = ""; };
      };
    };
  };
}
