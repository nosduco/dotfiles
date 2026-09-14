{ pkgs, ... }:
{
  # sesion
  home.sessionVariables = {
    EDITOR = "vim";
    ANDROID_HOME = "";
    PNPM_HOME = "";
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "$ANDROID_HOME/{emulator,platform-tools}"
    "$PNPM_HOME"
  ];

  # --- Session environment ---------------------------------------------------
  # home.sessionVariables : attrset  -> EDITOR, ANDROID_HOME, PNPM_HOME
  # home.sessionPath      : list     -> the fish_add_path lines:
  #     ~/.cargo/bin  ~/go/bin  ~/.local/bin  $ANDROID_HOME/{emulator,platform-tools}
  #     $PNPM_HOME  (DROP ~/.nix-profile/bin - profiles are on PATH already)
  # Written to hm-session-vars.sh; fish sources it automatically.

  # --- fish ----------------------------------------------------------------
  programs.fish = {
    # enable

    # shellAliases : attrset. Your 23 aliases, minus:
    #     DROP  pacman='paru'          (no pacman)
    #     DROP  cd="z"  cdi="zi"        (zoxide's --cmd cd below does this)
    #     DROP  nvm='fnm'               unless you keep fnm (see conf.d)
    #     ?     mux='tmuxinator'        tmuxinator is not installed anywhere

    # interactiveShellInit : lines. Only runs for interactive shells, so the
    # `if not status is-interactive; return; end` guard is implicit. Goes here:
    #     set fish_greeting
    #     fish_vi_key_bindings
    #     fish_user_key_bindings   (the function itself - see functions)
    #     the `if set -q nvim` alias block
    #     tabtab sourcing line     (pnpm completions - optional)
    #     fnm init, ONE line:  fnm env --use-on-cd | source
    #                          (conf.d/fnm.fish is 78 lines of frozen output;
    #                           the one-liner is what it expands from)
    #     DROP  zoxide init fish | source   -> programs.zoxide does this
    #     M3    posix-source ~/.env, and the ~/.dotfiles/.env loop

    # plugins : list of { name; src; }.
    #     src MUST be pkgs.fishPlugins.<x>.src  - the .src, not the package.
    #     (nixpkgs installs to share/fish/vendor_*.d; HM looks for functions/
    #      at the top of src. Passing the package silently loads nothing.)
    #     tide, bang-bang, fzf-fish are all packaged.
    #     DROP  virtualfish (not in nixpkgs, you use uv)

    # functions : attrset name -> BODY (HM adds the function..end wrapper).
    #     For tiny ones: fs, open_vim, open_yazi, vim.
    #     For dotenv (48 lines + 8 helpers) and ex (32): see below instead.

  };

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

  # --- tmux ------------------------------------------------------------------
  programs.tmux = {
    # enable

    # These tmux.conf lines have first-class options:
    #     set -g prefix C-a         -> shortcut = "a"   (or prefix = "C-a")
    #     set -s escape-time 0      -> escapeTime = 0
    #     set -g mode-keys vi       -> keyMode = "vi"
    #     set -g base-index 1       -> baseIndex = 1
    #     set -g mouse on           -> mouse = true
    #     set-option -g focus-events on -> focusEvents = true
    #     default-terminal tmux-256color -> terminal = "tmux-256color"
    #     default-shell /bin/fish   -> shell = "${pkgs.fish}/bin/fish"
    #                                  (/bin/fish DOES NOT EXIST on NixOS)

    # plugins : list. Bare package, or { plugin; extraConfig; } for ones
    # that take @settings. All four are packaged; note the attr names:
    #     tmuxPlugins.yank
    #     tmuxPlugins.extrakto
    #     tmuxPlugins.fingers   + "set -g @fingers-key f"
    #     tmuxPlugins.jump      + "set -g @jump-key 'Off'"
    #     DROP  tpm

    # extraConfig : everything else, as one '' '' string:
    #     the split/window binds, the is_vim block and C-hjkl/M-hjkl binds,
    #     copy-mode-vi binds, the colour/style lines, terminal-overrides,
    #     run-shell for the theme.
    #   Fix while porting:
    #     bind r source-file ~/.tmux.conf   -> ~/.config/tmux/tmux.conf
    #                                          (that's where HM writes it)
    #     DROP the tmux_version/bc block; tmux is 3.7, keep only the >=3.0
    #          bind for C-\ directly
    #     run-shell "~/.theme.tmux" -> keep the file via home.file below,
    #          or paste its contents in. catppuccin replaces it later.
    #     the C-v bind calls ~/.dotfiles/scripts/image-buffer-to-path.sh -
    #          that path holds until M9. Leave it.

  };

  # home.file.".theme.tmux".source = ... (if keeping the theme script as-is)
}
