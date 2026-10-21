
img=$(mktemp --suffix=.png)
trap 'rm -f "$img"' EXIT

grimblast --freeze save area "$img" >/dev/null || exit 0

if [[ ${1:-text} == qr ]]; then
  out=$(zbarimg -q --raw "$img" || true)
  copy=(wl-copy --sensitive)
else
  out=$(tesseract "$img" stdout 2>/dev/null || true)
  copy=(wl-copy)
fi

if [[ -z $out ]]; then
  notify-send -t 2000 "Scan" "Nothing found"
  exit 0
fi

printf '%s' "$out" | "${copy[@]}"
notify-send -t 2000 "Scan" "Copied to clipboard"
