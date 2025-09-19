# YouTube Liked Videos Downloader

A Bash script that uses [yt-dlp] to **mirror your YouTube "Liked Videos" playlist** into local **MP3 files** with thumbnails and metadata.  
Built for **personal use** on Linux Mint/Ubuntu, and tested with Brave cookies.

---

## Features
- Downloads audio-only (highest quality) as **MP3**  
- Embeds YouTube thumbnails as cover art  
- Adds title/metadata tags  
- Skips already downloaded songs (via `archive.txt`)  
- Uses your YouTube cookies for private playlist access  
- Handles retries & SABR streaming quirks with multiple passes  
- Logs all failed downloads into `failed.txt` for later retry  

---

## Project Structure
```
batch-yt-downloader/
├── liked-dl.sh       # main script
├── archive.txt       # keeps track of already-downloaded videos
├── failed.txt        # logs errors (video IDs/messages for retry)
└── downloads/        # MP3 files appear here
```


---

## Requirements

- **yt-dlp** (latest version recommended)  
  Install binary to avoid old repo versions:
  ```bash
  sudo apt remove yt-dlp -y   # remove old package
  sudo wget -O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp
  ```

- **ffmpeg** (for MP3 conversion & embedding thumbnails):
  ```bash
  sudo apt install ffmpeg
  ```

- **Brave browser** with an active YouTube login (cookies pulled automatically).  
  Works with Chrome/Chromium/Firefox too (replace `brave:Default` in script).

---

## Usage

1. Make the script executable:
   ```bash
   chmod +x liked-dl.sh
   ```

2. Run it:
   ```bash
   ./liked-dl.sh
   ```

3. New MP3s appear inside `downloads/`.  
   - Successful IDs go into `archive.txt`.  
   - Failed items are logged into `failed.txt`.  

---

## Script Details

- **Two-pass download strategy**  
  - **Pass 1**: Web client (with cookies, stable for Liked playlist).  
  - **Pass 2**: Default client retry (catches stubborn edge cases).  

- **Error logging**  
  - Any failed downloads are written to `failed.txt`.  
  - You can re-run only failed IDs later:
    ```bash
    yt-dlp -a failed.txt ...
    ```

- **yt-dlp options used**:
  - `--extract-audio --audio-format mp3 --audio-quality 0` → highest quality MP3  
  - `--embed-thumbnail --add-metadata` → embed cover art + tags  
  - `--download-archive archive.txt` → skip duplicates  
  - `--ignore-errors` → keep going if some fail  
  - `--concurrent-fragments 2` → faster HLS downloads  
  - `--force-ipv4` → avoids flaky IPv6 routes  

---

## Roadmap / Ideas
- [ ] Auto-sync daily via cron  
- [ ] Support arbitrary playlists (not just Liked)  
- [ ] Configurable audio formats (FLAC/OGG/AAC)  
- [ ] Smarter failed.txt (video IDs only)  

---

## ⚠️ Disclaimer
Downloading YouTube content may violate YouTube’s Terms of Service.  
This script is provided for **personal use only**. Please respect copyright and artists’ work.
