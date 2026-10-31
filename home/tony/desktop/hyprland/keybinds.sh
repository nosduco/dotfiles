
hyprctl binds -j | jq -r '
  def mods: .modmask as $m
    | [[64, "SUPER"], [4, "CTRL"], [8, "ALT"], [1, "SHIFT"]]
    | map(select(($m / .[0] | floor) % 2 == 1) | .[1]);
  .[] | select(.has_description) | "\(.description)  (\(mods + [.key] | join(" + ")))"
' | walker -d -p "Keybinds" >/dev/null || true
