#!/bin/bash
set -euo pipefail

ROOT="$HOME/Desktop/batch-yt-downloader"
OUTDIR="$ROOT/downloads"
ARCHIVE="$ROOT/archive.txt"
COOKIES="$ROOT/cookies.txt"
PLAYLIST_URL="https://www.youtube.com/playlist?list=LL"

# sanity checks
[ -s "$COOKIES" ] || { echo "!! cookies.txt missing or empty at: $COOKIES"; exit 1; }
command -v ffmpeg >/dev/null || { echo "!! ffmpeg not found. Install it: sudo apt install ffmpeg"; exit 1; }

mkdir -p "$OUTDIR"

yt-dlp \
  --cookies "$COOKIES" \
  --extractor-args "youtube:player_client=web" \
  --download-archive "$ARCHIVE" \
  --ignore-errors --no-abort-on-error \
  --retries infinite --fragment-retries infinite \
  -f "bestaudio/best" \
  --extract-audio --audio-format mp3 --audio-quality 0 \
  --embed-thumbnail --add-metadata \
  -o "$OUTDIR/%(title)s.%(ext)s" \
  "$PLAYLIST_URL"

