{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  dotfiles-check = pkgs.writeShellApplication {
    name = "dotfiles-check";
    runtimeInputs = [
      config.programs.git.package
      pkgs.coreutils
      pkgs.jq
      pkgs.libnotify
    ];
    text = ''
      cd ${osConfig.programs.nh.flake}
      state="''${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-check"
      mkdir -p "$state"
      notify() {
        if [ "$(cat "$state/$1" 2>/dev/null)" != "$2" ]; then
          notify-send -u critical -a System "$3" "$4" && echo "$2" > "$state/$1"
        fi
      }
      GIT_TERMINAL_PROMPT=0 timeout 60 git fetch --quiet --prune origin || true

      if [ -n "$(git rev-list main..origin/main)" ]; then
        notify generation "$(git rev-parse origin/main)" "Generation available" "$(git log --format=%s main..origin/main)"
      fi

      if git rev-parse -q --verify origin/flake-update >/dev/null; then
        inputs=$(jq -r --argjson new "$(git show origin/flake-update:flake.lock)" '
          def mods: .nodes as $n | $n[.root].inputs | with_entries(select(.value | type == "string") | .value = $n[.value].locked.lastModified);
          mods as $old | [$new | mods | to_entries[] | select($old[.key] and .value > $old[.key]) | .key] | join(", ")
        ' flake.lock)
        if [ -n "$inputs" ]; then
          notify updates "$(git rev-parse origin/flake-update:flake.lock)" "Updates ready" "$inputs"
        fi
      fi

      rev=$(/run/current-system/sw/bin/nixos-version --configuration-revision || true)
      if [ -n "$(git rev-list origin/main..main)" ] || { [ "$rev" = "$(git rev-parse main)-dirty" ] && ! git diff --quiet HEAD; }; then
        notify unpushed "$(git rev-parse main) $rev" "Unpushed changes" "Commit and push ${osConfig.programs.nh.flake}."
      fi
    '';
  };
in
{
  # updates
  systemd.user.services.dotfiles-check = {
    Unit.Description = "dotfiles update check";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe dotfiles-check;
    };
  };
  systemd.user.timers.dotfiles-check = {
    Unit.Description = "dotfiles update check";
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
