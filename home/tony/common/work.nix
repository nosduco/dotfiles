{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  secret = name: config.lib.file.mkOutOfStoreSymlink osConfig.sops.secrets.${name}.path;
in
{
  # aws vpn
  home.activation.awsvpnclient-metrics = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${pkgs.writeText "Preferences" ''{"Version":"1","IsMetricsEnabled":false}''} \
      "$HOME/.config/AWSVPNClient/Preferences"
  '';

  # credentials
  home.file = {
    ".npmrc".source = secret "npmrc";
    ".aws/config".source = secret "aws-config";
    ".aws/credentials".source = secret "aws-credentials";
    ".snowsql/config".source = secret "snowsql-config";
    ".snowflake/connections.toml".source = secret "snowflake-connections";
    ".edge-cli.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.edge-cli/config.toml";
  };

  # apps
  home.packages = [
    pkgs.mongosh
    pkgs.snowsql
  ];
}
