{
  # networkmanager
  networking.networkmanager.enable = true;
  users.users.tony.extraGroups = [ "networkmanager" ];

  # wifi
  boot.extraModprobeConfig = "options cfg80211 ieee80211_regdom=US";

  # resolved
  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = [
      "9.9.9.9#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
  };

  # syncthing
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7340032;
    "net.core.wmem_max" = 7340032;
  };

  # tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraSetFlags = [ "--ssh=false" ];
  };
  systemd.services.tailscaled-set.serviceConfig.RemainAfterExit = true;

  # ssh
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  users.users.tony.openssh.authorizedKeys.keyFiles = [ ../../../keys/authorized_keys ];
}
