{ config, osConfig, pkgs, ... }:
{
  # neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    sideloadInitLua = true;
    extraPackages = with pkgs; [
      # lsp
      lua-language-server
      tofu-ls
      nixd
      vscode-langservers-extracted
      yaml-language-server
      pyright
      jdt-language-server
      # format
      astyle
      eslint_d
      markdownlint-cli
      nixfmt
      opentofu
      prettier
      ruff
      rustfmt
      stylua
      # lint
      actionlint
      codespell
      deadnix
      hadolint
      lua51Packages.luacheck
      sqlfluff
      statix
      tfsec
      yamllint
      # treesitter
      gcc
      # dap
      vscode-js-debug
    ];
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${osConfig.programs.nh.flake}/config/nvim";

  programs.fish.shellAliases.svim = "sudo -E nvim";
}
