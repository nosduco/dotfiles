{ osConfig, ... }:
{
  # ssh
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ osConfig.sops.secrets.ssh-hosts.path ];
    settings = {
      "*".AddKeysToAgent = "yes";
      "pve pve.tux" = {
        HostName = "pve.tux.nosnet";
        User = "root";
        ForwardAgent = "yes";
      };
      "gameserver gameserver.tux" = {
        HostName = "gameserver.tux.nosnet";
        User = "tony";
      };
      "home home.tux" = {
        HostName = "home.tux.nosnet";
        User = "root";
      };
      "daemon daemon.tux".HostName = "daemon.tux.nosnet";
    };
  };
}
