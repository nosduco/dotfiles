title=${NTFY_TITLE:-$NTFY_TOPIC}
case "${NTFY_PRIORITY:-3}" in
  1 | 2) urgency=low ;;
  4 | 5) urgency=critical ;;
  *) urgency=normal ;;
esac
args=(-a ntfy -u "$urgency")

image=$(jq -r 'select(.attachment.type // "" | startswith("image/")) | .attachment.url' <<<"$NTFY_RAW")
if [ -n "$image" ]; then
  dir="$XDG_RUNTIME_DIR/ntfy"
  mkdir -p "$dir"
  find "$dir" -type f -mmin +1440 -delete
  if curl -fsS --max-time 20 --max-filesize 15M -o "$dir/$NTFY_ID" "$image"; then
    args+=(-c ntfy.image -i "$dir/$NTFY_ID")
  fi
fi

click=$(jq -r '.click // empty' <<<"$NTFY_RAW")
if [ -n "$click" ]; then
  # ntfy runs this per message and waits; -A blocks until the notification closes
  {
    if [ "$(notify-send "${args[@]}" -A default=Open "$title" "$NTFY_MESSAGE")" = default ]; then
      xdg-open "$click"
    fi
  } </dev/null >/dev/null 2>&1 &
else
  notify-send "${args[@]}" "$title" "$NTFY_MESSAGE"
fi
