{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  mount = "${config.home.homeDirectory}/cloud";
  rcloneConfig = osConfig.sops.secrets.rclone-tuxcloud.path;
in
{
  # tuxcloud
  home.packages = [ pkgs.rclone ];
  gtk.gtk3.bookmarks = [ "file://${mount} tuxcloud" ];
  systemd.user.services.rclone-tuxcloud = {
    Unit = {
      Description = "rclone mount: tuxcloud at ~/cloud";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
      ConditionPathExists = rcloneConfig;
    };
    Service = {
      Type = "notify";
      Environment = [
        "RCLONE_CONFIG=${rcloneConfig}"
        "PATH=/run/wrappers/bin"
      ];
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mount}";
      ExecStart = "${pkgs.rclone}/bin/rclone mount tuxcloud: ${mount} --cache-dir ${config.xdg.cacheHome}/rclone --vfs-cache-mode full --vfs-cache-max-size 10G --vfs-cache-max-age 168h --dir-cache-time 5m --poll-interval 0 --attr-timeout 5s --timeout 30s --contimeout 15s --low-level-retries 5 --umask 022 --dir-perms 0755 --file-perms 0644 --log-level INFO";
      ExecStop = "/run/wrappers/bin/fusermount3 -uz ${mount}";
      Restart = "on-failure";
      RestartSec = "30s";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
