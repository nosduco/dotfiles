{ pkgs, ... }:
{
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
  ];

  # node
  programs.fish.interactiveShellInit = "fnm env --use-on-cd | source";
  programs.fish.shellAliases.nvm = "fnm";

  # clipboard
  services.wl-clip-persist = {
    enable = true;
    clipboardType = "regular";
  };

  # toolchains
  home.packages = with pkgs; [
    android-studio
    android-tools
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

    # infra
    ansible
    awscli2
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
