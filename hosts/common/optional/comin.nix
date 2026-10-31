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
  };
  systemd.services.comin = {
    unitConfig = {
      StartLimitIntervalSec = 300;
      StartLimitBurst = 5;
    };
    serviceConfig.RestartSec = 30;
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

  # dotfiles
  home-manager.users.tony =
    { lib, ... }:
    let
      git = lib.getExe pkgs.git;
      dir = config.programs.nh.flake;
    in
    {
      home.activation.dotfiles-pull = lib.hm.dag.entryAfter [ "dotfiles" ] ''
        if [ "$(${git} -C ${dir} branch --show-current 2>/dev/null)" = main ]; then
          run env GIT_TERMINAL_PROMPT=0 ${pkgs.coreutils}/bin/timeout 30 ${git} -C ${dir} pull --quiet --ff-only \
            || warnEcho "could not fast-forward ${dir}, pull it by hand"
        fi
      '';
    };
}
