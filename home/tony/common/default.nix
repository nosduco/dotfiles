{
  imports = [
    ./theme.nix
    ./credentials.nix
    ./syncthing
    ./dev.nix
    ./work.nix
    ./shell.nix
    ./tide.nix
    ./git.nix
    ./ssh.nix
    ./neovim.nix
    ./cli.nix
    ./herdr.nix
  ];

  home.stateVersion = "26.05";
}
