{ config, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # sops
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
  };

  # secrets
  sops.secrets = {
    rclone-tuxcloud.owner = "tony";
    ssh-hosts.owner = "tony";
    env.owner = "tony";
    syncthing-cert = {
      owner = "tony";
      key = "syncthing-cert-${config.networking.hostName}";
    };
    syncthing-key = {
      owner = "tony";
      key = "syncthing-key-${config.networking.hostName}";
    };
    kopia-password = {
      owner = "tony";
      key = "kopia-password-${config.networking.hostName}";
    };
  };
}
