{
  config,
  pkgs,
  lib,
  ...
}:
let
  herdr = lib.getExe config.programs.herdr.package;
in
{
  # android
  home.packages = [ pkgs.android-studio ];

  # clipboard
  services.wl-clip-persist = {
    enable = true;
    clipboardType = "regular";
  };

  # herdr server
  systemd.user.services.herdr = {
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # herdr machines
  home.activation.herdrMachines = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${herdr} machine list --json | ${lib.getExe pkgs.jq} -e 'any(.label == "daemon")' >/dev/null; then
      run timeout 10 ${herdr} machine add daemon.tux.nosnet --label daemon </dev/null || true
    fi
  '';
}
