#!/bin/bash
set -euo pipefail

ROOT="$HOME/Desktop/batch-yt-downloader"
OUTDIR="$ROOT/downloads"
ARCHIVE="$ROOT/archive.txt"
FAILED="$ROOT/failed.txt"
PLAYLIST_URL="https://www.youtube.com/playlist?list=LL"

# sanity check
command -v ffmpeg >/dev/null || { echo "!! ffmpeg not found. sudo apt install ffmpeg"; exit 1; }
mkdir -p "$OUTDIR"

# clear old fail list
: > "$FAILED"

COMMON=(
  --download-archive "$ARCHIVE"
  --ignore-errors --no-abort-on-error
  --match-filter "duration < 14400"
  -f "bestaudio/best"
  --extract-audio --audio-format mp3 --audio-quality 0
  --embed-thumbnail --add-metadata
  --retries 10 --fragment-retries 10 --retry-sleep 2
  --concurrent-fragments 2
  --force-ipv4
  -o "$OUTDIR/%(title)s.%(ext)s"
  "$PLAYLIST_URL"
)

echo "[pass 1] Web client (with cookies, main run)…"
yt-dlp --cookies-from-browser brave:Default \
       --extractor-args "youtube:player_client=web" \
       "${COMMON[@]}" \
       2>&1 | tee >(grep "ERROR:" >> "$FAILED") || true

echo "[pass 2] Default client retry (only for items not done yet)…"
yt-dlp --cookies-from-browser brave:Default \
       --extractor-args "" \
       "${COMMON[@]}" \
       2>&1 | tee >(grep "ERROR:" >> "$FAILED") || true

echo "✅ Done. Archive prevents dupes."
echo "⚠️ Failed items logged to: $FAILED"
