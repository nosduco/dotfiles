{ config, pkgs, ... }:
{
  # android
  home.sessionVariables.ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    stdlib = ''
      layout_uv() {
        [[ -d .venv ]] || uv venv --quiet
        export VIRTUAL_ENV="$PWD/.venv"
        PATH_add "$VIRTUAL_ENV/bin"
      }
    '';
  };
  programs.git.ignores = [
    ".envrc"
    ".direnv/"
    "**/.claude/settings.local.json"
  ];

  # node
  programs.fish.interactiveShellInit = "fnm env --use-on-cd | source";
  programs.fish.shellAliases.nvm = "fnm";

  # clipboard
  services.wl-clip-persist = {
    enable = true;
    clipboardType = "regular";
  };

  # pi
  programs.pi-coding-agent = {
    enable = true;
    mutableSettings = true;
  };

  # toolchains
  home.packages = with pkgs; [
    android-studio
    android-tools
    bun
    cargo-tauri
    dioxus-cli
    fnm
    nodejs
    pnpm
    python3
    rojo
    ruby
    rustup
    trunk
    uv
    yarn

    # ai
    claude-code
    codex
    cursor-cli
    rtk

    # lsp
    lua-language-server
    pyright
    typescript-language-server

    # infra
    ansible
    awscli2
    fluxcd
    kubectl
    kubernetes-helm
    kustomize
    opentofu
    ssm-session-manager-plugin
    talosctl
    terraform
    vault

    # cli
    _7zz
    ddrescue
    dnsutils
    gita
    inetutils
    just
    ldns
    ncdu
    pdftk
    pngquant
    scdl
    sshfs
    tcpdump
    yt-dlp
  ];
}
