{
  config,
  lib,
  pkgs,
  ...
}:
let
  voyager-power = pkgs.writeShellApplication {
    name = "voyager-power";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      gawk
      power-profiles-daemon
      systemd
      util-linux
    ];
    text = ''
      online=$(cat /sys/class/power_supply/A*/online 2>/dev/null | head -1)
      [ -z "$online" ] && exit 0
      if [ "$online" = 1 ]; then mode=ac profile=balanced gpu=auto; else mode=battery profile=power-saver gpu=low; fi

      busctl --system call net.hadess.PowerProfiles /net/hadess/PowerProfiles \
        org.freedesktop.DBus.Properties Set ssv net.hadess.PowerProfiles ActiveProfile s "$profile" \
        >/dev/null 2>&1 || true

      for d in /sys/class/drm/card*/device; do
        [ -f "$d/power_dpm_force_performance_level" ] && echo "$gpu" > "$d/power_dpm_force_performance_level" 2>/dev/null || true
      done
      for f in /sys/class/nvme/nvme*/device/power/control; do
        [ -w "$f" ] && echo auto > "$f" 2>/dev/null || true
      done
      for d in /sys/bus/pci/devices/*/; do
        if [ "$(cat "$d/vendor")" = 0x14c3 ] && [ "$(cat "$d/device")" = 0x7922 ]; then
          echo auto > "$d/power/control" 2>/dev/null || true
        fi
      done

      logger -t voyager-power "applied $mode: PPD=$(powerprofilesctl get 2>/dev/null) GPU=$gpu"
    '';
  };
  deferred-hibernate = pkgs.writeShellApplication {
    name = "voyager-deferred-hibernate";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      systemd
      util-linux
    ];
    text = ''
      delay=7200
      slack=60
      rtc=/sys/class/rtc/rtc0/wakealarm
      stamp=/run/voyager-deferred-hibernate.deadline

      on_battery() { [ "$(cat /sys/class/power_supply/A*/online 2>/dev/null | head -1)" = 0 ]; }
      lid_open() { grep -qi open /proc/acpi/button/lid/*/state 2>/dev/null; }
      arm_rtc() {
        local when="$1" now
        now=$(date +%s)
        [ "$when" -lt "$((now + 30))" ] && when=$((now + 30))
        echo 0 > "$rtc" 2>/dev/null || true
        echo "$when" > "$rtc" 2>/dev/null || true
      }

      case "$1" in
        pre)
          { [ "$2" = suspend ] && on_battery; } || exit 0
          now=$(date +%s)
          deadline=$(cat "$stamp" 2>/dev/null || echo 0)
          if [ "$deadline" -eq 0 ] || [ "$now" -gt "$((deadline + 120))" ]; then
            deadline=$((now + delay))
            echo "$deadline" > "$stamp"
            logger -t voyager-hibernate "hibernating at deadline (+''${delay}s) unless lid opens or AC returns"
          fi
          arm_rtc "$deadline"
          ;;
        post)
          { [ "$2" = suspend ] && [ -e "$stamp" ]; } || exit 0
          if lid_open || ! on_battery; then
            rm -f "$stamp"
            echo 0 > "$rtc" 2>/dev/null || true
            exit 0
          fi
          now=$(date +%s)
          deadline=$(cat "$stamp" 2>/dev/null || echo 0)
          if [ "$((deadline - now))" -le "$slack" ]; then
            rm -f "$stamp"
            echo 0 > "$rtc" 2>/dev/null || true
            logger -t voyager-hibernate "deadline reached, hibernating"
            systemd-run --on-active=3 --timer-property=AccuracySec=1s systemctl hibernate
          fi
          ;;
      esac
    '';
  };
in
{
  # scheduler
  services.system76-scheduler.enable = true;
  environment.etc."system76-scheduler/config.kdl".source = lib.mkForce (
    pkgs.runCommand "config.kdl" { } ''
      sed 's/execsnoop true/execsnoop false/' ${config.services.system76-scheduler.package}/data/config.kdl > $out
    ''
  );

  # profiles
  services.power-profiles-daemon.enable = true;
  systemd.services.voyager-power = {
    description = "Apply voyager AC/battery power state";
    after = [ "power-profiles-daemon.service" ];
    wants = [ "power-profiles-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe voyager-power;
    };
  };

  # runtime pm
  boot.kernelParams = [
    "amdgpu.abmlevel=1"
    "8250.nr_uarts=0"
  ];
  boot.extraModprobeConfig = "options snd_hda_intel power_save=1 power_save_controller=Y";
  systemd.tmpfiles.rules = [ "w- /sys/module/pcie_aspm/parameters/policy - - - - powersave" ];

  # hibernate
  environment.etc."systemd/system-sleep/voyager-deferred-hibernate".source =
    lib.getExe deferred-hibernate;

  # updates on battery
  systemd.services.comin-power = {
    after = [ "comin.service" ];
    wantedBy = [ "comin.service" ];
    path = [
      config.services.comin.package
      config.systemd.package
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      until comin status >/dev/null 2>&1; do sleep 2; done
      if systemd-ac-power; then comin resume; else comin suspend; fi || true
    '';
  };

  # udev
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${config.systemd.package}/bin/systemctl start --no-block voyager-power.service comin-power.service"
    ACTION=="add", SUBSYSTEM=="nvme", ATTR{power/control}="auto"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x14c3", ATTR{device}=="0x7922", ATTR{power/control}="auto"
  '';
}
