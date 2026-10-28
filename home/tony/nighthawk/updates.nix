{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  os-update-check = pkgs.writeShellApplication {
    name = "os-update-check";
    runtimeInputs = [
      config.programs.git.package
      pkgs.coreutils
      pkgs.jq
      pkgs.libnotify
    ];
    text = ''
      cd ${osConfig.programs.nh.flake}
      state="''${XDG_STATE_HOME:-$HOME/.local/state}/os-update-check"
      mkdir -p "$state"
      notify() {
        if [ "$(cat "$state/$1" 2>/dev/null)" != "$2" ]; then
          notify-send -u critical -a System -h "string:x-dunst-stack-tag:$1" "$3" "$4" && echo "$2" > "$state/$1"
        fi
      }
      GIT_TERMINAL_PROMPT=0 timeout 60 git fetch --quiet --prune origin || true

      if [ -n "$(git rev-list main..origin/main)" ]; then
        notify generation "$(git rev-parse origin/main)" "Generation available" "$(git log --format=%s main..origin/main)"
      fi

      age=$(( ($(date +%s) - $(git log -1 --format=%ct main -- flake.lock)) / 86400 ))
      if [ "$age" -ge 7 ] && git rev-parse -q --verify origin/flake-update >/dev/null; then
        inputs=$(jq -r --argjson new "$(git show origin/flake-update:flake.lock)" '
          def mods: .nodes as $n | $n[.root].inputs | with_entries(select(.value | type == "string") | .value = $n[.value].locked.lastModified);
          mods as $old | [$new | mods | to_entries[] | select($old[.key] and .value > $old[.key]) | .key] | join(", ")
        ' flake.lock)
        if [ -n "$inputs" ]; then
          notify updates "$(date +%F)" "Updates ready" "Last update $age days ago: $inputs"
        fi
      fi

      rev=$(/run/current-system/sw/bin/nixos-version --configuration-revision || true)
      if [ -n "$(git rev-list origin/main..main)" ] || { [ "$rev" = "$(git rev-parse main)-dirty" ] && ! git diff --quiet HEAD; }; then
        notify unpushed "$(git rev-parse main) $rev" "Unpushed changes" "Commit and push ${osConfig.programs.nh.flake}."
      fi

      if [ "$(readlink /run/booted-system/{initrd,kernel,kernel-modules})" != "$(readlink /run/current-system/{initrd,kernel,kernel-modules})" ]; then
        notify reboot "$(readlink /run/current-system)" "Reboot needed" "Kernel or initrd changed since boot."
      fi
    '';
  };
  os-update = pkgs.writeShellApplication {
    name = "os-update";
    runtimeInputs = [
      config.programs.git.package
      osConfig.programs.nh.package
    ];
    text = ''
      cd ${osConfig.programs.nh.flake}
      if ! git diff --quiet HEAD -- flake.lock; then
        echo "flake.lock has uncommitted changes: commit it or git checkout HEAD -- flake.lock" >&2
        exit 1
      fi
      git pull --quiet --ff-only --prune
      if ! git rev-parse -q --verify origin/flake-update >/dev/null || git diff --quiet HEAD origin/flake-update -- flake.lock; then
        echo "No updates"
        exit 0
      fi
      git checkout origin/flake-update -- flake.lock
      if nh os switch -a; then
        git commit --quiet -m "chore(flake): update inputs" flake.lock
        git push --quiet
      else
        git checkout HEAD -- flake.lock
        exit 1
      fi
    '';
  };
in
{
  # updates
  home.packages = [ os-update ];
  systemd.user.services.os-update-check = {
    Unit.Description = "os update check";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe os-update-check;
    };
  };
  systemd.user.timers.os-update-check = {
    Unit.Description = "os update check";
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
