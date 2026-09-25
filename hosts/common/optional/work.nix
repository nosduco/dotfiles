{ inputs, lib, ... }:
{
  imports = [ inputs.awsvpnclient-nix.nixosModules.default ];

  # aws vpn
  services.awsvpnclient = {
    enable = true;
    installGui = false;
  };
  systemd.services.awsvpnclient.wantedBy = lib.mkForce [ ];
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "awsvpnclient.service" &&
          subject.user == "tony") {
        var verb = action.lookup("verb");
        if (verb == "start" || verb == "stop" || verb == "restart") {
          return polkit.Result.YES;
        }
      }
    });
  '';

  # credentials
  sops.secrets = {
    npmrc.owner = "tony";
    aws-config.owner = "tony";
    aws-credentials.owner = "tony";
    snowsql-config.owner = "tony";
  };
}
