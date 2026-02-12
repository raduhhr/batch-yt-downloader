#!/usr/bin/env bash
set -euo pipefail

# =====================================================================
# YouTube Music Downloader – Clean filenames, playlist subfolders
# =====================================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${ROOT:-$SCRIPT_DIR}"

OUTDIR="${OUTDIR:-$ROOT/downloads}"
ARCHIVE="${ARCHIVE:-$ROOT/archive.txt}"
LOG_DIR="${LOG_DIR:-$ROOT/logs}"

BROWSER_PROFILE="${BROWSER_PROFILE:-Default}"
MAX_DURATION="${MAX_DURATION:-14400}"
CONCURRENT_FRAGMENTS="${CONCURRENT_FRAGMENTS:-3}"

DEFAULT_URL="${PLAYLIST_URL:-https://www.youtube.com/playlist?list=LL}"

# Interactive URL prompt
if [[ $# -ge 1 ]]; then
    PLAYLIST_URL="$1"
else
    if [[ -t 0 ]]; then
        read -p "Enter playlist/video URL [default: Liked videos]: " USER_URL
        PLAYLIST_URL="${USER_URL:-$DEFAULT_URL}"
    else
        PLAYLIST_URL="$DEFAULT_URL"
    fi
fi

mkdir -p "$OUTDIR" "$LOG_DIR"
touch "$ARCHIVE"

TIMESTAMP="$(date +'%Y%m%d-%H%M%S')"
LOG_FILE="$LOG_DIR/run-$TIMESTAMP.log"

log() { echo "[$(date +'%H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

# Dependency check
for cmd in yt-dlp ffmpeg; do
    command -v "$cmd" >/dev/null || { echo "Error: $cmd not installed"; exit 1; }
done

log "Downloading from: $PLAYLIST_URL"
log "Output: $OUTDIR"
log ""

yt-dlp \
    --cookies-from-browser "brave:${BROWSER_PROFILE}" \
    --download-archive "$ARCHIVE" \
    --ignore-errors \
    --no-abort-on-error \
    --retries 5 \
    --fragment-retries 5 \
    --concurrent-fragments "$CONCURRENT_FRAGMENTS" \
    --match-filter "duration < ${MAX_DURATION}" \
    --remote-components ejs:npm \
    --progress \
    --newline \
    -f "bestaudio/best" \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    -o "$OUTDIR/%(playlist_title|Misc)s/%(title).200B.%(ext)s" \
    "$PLAYLIST_URL" 2>&1 | tee -a "$LOG_FILE"

log "Done. Log: $LOG_FILE"
