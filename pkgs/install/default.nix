{
  writeShellApplication,
  lib,
  age,
  coreutils,
  findutils,
  git,
  gnused,
  nixos-anywhere,
  openssh,
  hosts,
}:
writeShellApplication {
  name = "install";
  runtimeInputs = [
    age
    coreutils
    findutils
    git
    gnused
    nixos-anywhere
    openssh
  ];
  runtimeEnv.HOSTS = lib.concatStringsSep " " hosts;
  text = builtins.readFile ./install.sh;
}
