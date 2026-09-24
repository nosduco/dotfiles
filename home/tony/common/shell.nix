{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  tmux-power = pkgs.tmuxPlugins.power-theme.overrideAttrs (_: {
    version = "unstable-2026-03-31";
    src = inputs.tmux-power;
  });
  image-buffer-to-path = pkgs.writeShellApplication {
    name = "image-buffer-to-path";
    runtimeInputs = [ pkgs.wl-clipboard ];
    text = ''
      types=$(wl-paste --list-types)
      if grep -q '^image/' <<<"$types"; then
        ext=$(grep -m1 '^image/' <<<"$types" | cut -d/ -f2 | cut -d';' -f1)
        file="/tmp/clip_$(date +%s).''${ext}"
        wl-paste > "$file"
        printf '%q' "$file"
      else
        wl-paste --no-newline
      fi
    '';
  };
in
{
  # --- Session environment ---------------------------------------------------
  # home.sessionVariables : attrset  -> EDITOR, ANDROID_HOME, PNPM_HOME
  # home.sessionPath      : list     -> the fish_add_path lines:
  #     ~/.cargo/bin  ~/go/bin  ~/.local/bin  $ANDROID_HOME/{emulator,platform-tools}
  #     $PNPM_HOME  (DROP ~/.nix-profile/bin - profiles are on PATH already)
  # Written to hm-session-vars.sh; fish sources it automatically.

  # fish
  programs.fish = {
    enable = true;

    shellAliases = {
      bell = ''echo -e "\a"'';
    };

    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
    '';

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "bang-bang";
        src = pkgs.fishPlugins.bang-bang.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };

  # eza
  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [ "--time-style=+%a %b %d %I:%M:%S %p %Y" ];
  };

  # fish functions
  xdg.configFile."fish/functions" = {
    source = ../../../config/fish/functions;
    recursive = true;
  };
  xdg.configFile."fish/completions" = {
    source = ../../../config/fish/completions;
    recursive = true;
  };

  # zoxide
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };
  home.packages = with pkgs; [
    fd
    wl-clipboard
  ];

  # Existing function FILES, kept verbatim. xdg.configFile."fish/functions/x.fish"
  # coexists with programs.fish because HM writes files by name and these
  # names don't collide. Store-copied (a relative path is fine here - these
  # aren't tinker-loop files, and you chose declarative).
  #     dotenv.fish + _dotenv_*.fish, ex.fish, fish_user_key_bindings.fish

  # --- zoxide ----------------------------------------------------------------
  # programs.zoxide.enable
  # programs.zoxide.options = [ "--cmd" "cd" ];
  #     -> z becomes cd, zi becomes cdi. Replaces both aliases AND the
  #        manual `zoxide init` line. Fish integration defaults to on.

  # tmux
  catppuccin.tmux.enable = false;
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    shortcut = "a";
    keyMode = "vi";
    escapeTime = 0;
    baseIndex = 1;
    mouse = true;
    focusEvents = true;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = tmux-power;
        extraConfig = ''
          set -g @tmux_power_theme '#fab387'
          set -g @tmux_power_g0 '#1e1e2e'
          set -g @tmux_power_g1 '#1e1e2e'
          set -g @tmux_power_g2 '#181825'
          set -g @tmux_power_g3 '#313244'
          set -g @tmux_power_g4 '#cdd6f4'
          set -g @tmux_power_left_a ' #h'
          set -g @tmux_power_left_b '''
          set -g @tmux_power_right_y ' %I:%M%p'
          set -g @tmux_power_right_z ' %m/%d/%y'
        '';
      }
      yank
      extrakto
      vim-tmux-navigator
      {
        plugin = fingers;
        extraConfig = "set -g @fingers-key f";
      }
      {
        plugin = jump;
        extraConfig = "set -g @jump-key 'Off'";
      }
    ];

    extraConfig = ''
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

      bind s split-window -v -c "#{pane_current_path}"
      bind i split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      unbind '"'
      unbind %
      bind j choose-tree
      bind v copy-mode
      bind p paste-buffer
      bind -T copy-mode-vi Escape send-keys -X cancel
      bind -T copy-mode-vi s run-shell -b "${pkgs.tmuxPlugins.jump}/share/tmux-plugins/jump/scripts/tmux-jump.sh"

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+/)?g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?$'"
      bind -n M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 3'
      bind -n M-j if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 3'
      bind -n M-k if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 3'
      bind -n M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 3'
      bind -n C-v if-shell "$is_vim" 'send-keys C-v' 'run-shell -b "${lib.getExe image-buffer-to-path} | tmux load-buffer -; tmux paste-buffer"'
    '';
  };
}
