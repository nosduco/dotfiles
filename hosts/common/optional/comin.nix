{
  config,
  inputs,
  lib,
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
        branches.main.name = "main";
      }
    ];
    sshAllowedSignersPath = "${../../../keys/allowed_signers}";
    desktop = {
      enable = true;
      title = "System";
    };
  };

  # comin boot entry
  services.comin.postDeploymentCommand = pkgs.writeShellScript "comin-boot-entry" ''
    [ "$COMIN_STATUS" = done ] || exit 0
    system=$(readlink -f /nix/var/nix/profiles/system-profiles/comin)
    [ "$system" = "$(readlink -f /run/current-system)" ] || exit 0
    ${lib.getExe' config.nix.package "nix-env"} -p /nix/var/nix/profiles/system --set "$system" \
      && "$system/bin/switch-to-configuration" boot
  '';

  # comin vm
  virtualisation.vmVariant.services.comin = {
    hostname = "vmtest";
    remotes = lib.mkForce [
      {
        name = "vmtest";
        url = "/var/lib/comin-vmtest";
        branches.main.name = "main";
        poller.period = 5;
      }
    ];
    sshAllowedSignersPath = lib.mkForce "/var/lib/comin-vmtest-signers";
  };

  # alerts
  systemd.user.services.comin-desktop = {
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 10;
      ExecStartPost = "-${pkgs.writeShellScript "comin-reboot-check" ''
        ${lib.getExe config.services.comin.package} status --json | ${lib.getExe pkgs.jq} -e .need_to_reboot >/dev/null \
          && ${lib.getExe pkgs.libnotify} ${config.services.comin.desktop.title} "The machine needs to be rebooted to take the deployment into account."
      ''}";
    };
  };
  home-manager.users.tony =
    { lib, ... }:
    let
      git = lib.getExe pkgs.git;
      dir = config.programs.nh.flake;
      summary = config.services.comin.desktop.title;
      after = lib.hm.dag.entryAfter [ "comin" ];
      quiet =
        body:
        after {
          inherit summary body;
          skip_display = true;
          history_ignore = true;
        };
    in
    {
      services.dunst.settings = {
        comin = {
          inherit summary;
          new_icon = "system-software-update";
        };
        comin-started = quiet "Agent desktop notifications started.";
        comin-suspended = quiet "The agent is suspended.";
        comin-resumed = quiet "The agent is resumed.";
        comin-building = quiet "A new commit from *";
        comin-deploying = quiet "A deployment started.";
        comin-deployed = quiet "The deployment is finished.";
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

      # dotfiles
      home.activation.dotfiles-pull = lib.hm.dag.entryAfter [ "dotfiles" ] ''
        if [ "$(${git} -C ${dir} branch --show-current 2>/dev/null)" = main ]; then
          run env GIT_TERMINAL_PROMPT=0 ${pkgs.coreutils}/bin/timeout 30 ${git} -C ${dir} pull --quiet --ff-only \
            || warnEcho "could not fast-forward ${dir}, pull it by hand"
        fi
      '';
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
