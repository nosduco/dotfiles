
in=$1
out="${in%.*}-share.mp4"
limit=19000000

set -o errtrace
trap 'notify-send -u critical "Recording" "Share copy failed: $in"' ERR

encode() {
  ffmpeg -v error -y -i "$in" -vf "scale=-2:'min(1080,ih)'" -c:v libx264 -preset medium "$@"
}

encode -crf 23 -c:a aac -b:a 128k -movflags +faststart "$out"

if (($(stat -c %s "$out") > limit)); then
  secs=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$in")
  rate=$((limit * 8 * 95 / 100 / (${secs%.*} + 1) - 128000))
  log=$(mktemp -d)
  encode -b:v "$rate" -pass 1 -passlogfile "$log/pass" -an -f null /dev/null
  encode -b:v "$rate" -pass 2 -passlogfile "$log/pass" -c:a aac -b:a 128k -movflags +faststart "$out"
  rm -rf "$log"
fi

wl-copy -t text/uri-list "file://$(realpath "$out")"
notify-send -t 5000 "Recording" "Share copy ready, file copied"
