{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.comin.nixosModules.comin ];

  # comin
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/nosduco/dotfiles.git";
        # TODO: switch to main after M9 merge
        branches.main.name = "nixos";
      }
    ];
    sshAllowedSignersPath = "${../../../keys/allowed_signers}";
    desktop = {
      enable = true;
      title = "System";
    };
  };

  # alerts
  systemd.user.services.comin-desktop = {
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
  home-manager.users.tony =
    { lib, ... }:
    let
      summary = config.services.comin.desktop.title;
      after = lib.hm.dag.entryAfter [ "comin" ];
    in
    {
      services.dunst.settings = {
        comin = {
          inherit summary;
          new_icon = "system-software-update";
        };
        comin-started = after {
          inherit summary;
          body = "Agent desktop notifications started.";
          skip_display = true;
          history_ignore = true;
        };
        comin-reboot = after {
          inherit summary;
          body = "*rebooted*";
          new_icon = "system-reboot";
        };
        comin-failed = after {
          inherit summary;
          body = "*failed*";
          new_icon = "dialog-error";
        };
        comin-broken = after {
          inherit summary;
          body = "*broken*";
          new_icon = "dialog-error";
        };
      };
    };
  systemd.services.comin = {
    unitConfig = {
      OnFailure = [ "comin-failed.service" ];
      StartLimitIntervalSec = 300;
      StartLimitBurst = 5;
    };
    serviceConfig.RestartSec = 30;
  };
  systemd.services.comin-failed = {
    serviceConfig.Type = "oneshot";
    script = ''
      [ "$(${config.systemd.package}/bin/systemctl show comin -P Result)" = start-limit-hit ] || exit 0
      ${config.systemd.package}/bin/systemd-run --user --machine=tony@ --quiet \
        ${pkgs.libnotify}/bin/notify-send -u critical -a System System "Auto-update is broken. journalctl -u comin"
    '';
  };
}
