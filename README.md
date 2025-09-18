# YouTube Liked Videos Downloader

A simple Bash script that uses [yt-dlp](https://github.com/yt-dlp/yt-dlp) to **mirror your YouTube "Liked Videos" playlist** into local **MP3 files** with thumbnails and metadata.

---

## Features
- Downloads audio-only (highest quality) as **MP3**  
- Embeds YouTube thumbnails as cover art  
- Adds title/metadata tags  
- Skips already downloaded songs (uses an archive file)  
- Uses your YouTube cookies for private playlist access  
- Works on Linux Mint / Ubuntu and similar distros  

---

## Project Structure
```
batch-yt-downloader/
├── liked-dl.sh       # main script
├── cookies.txt       # exported YouTube cookies (not tracked in git)
├── archive.txt       # keeps track of already-downloaded videos
└── downloads/        # MP3 files will appear here
```

---

## Requirements

- **yt-dlp** (latest version recommended)  
  Install either via pipx or binary:
  ```bash
  sudo apt remove yt-dlp -y   # remove old package
  sudo wget -O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp
  ```

- **ffmpeg** (for MP3 conversion & embedding thumbnails):
  ```bash
  sudo apt install ffmpeg
  ```

- A YouTube account with liked videos.

---

## Authentication (cookies.txt)

Because the "Liked videos" playlist is private, you need to export your YouTube login cookies:

1. Install the [Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc) extension in Chromium/Chrome (or [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/) in Firefox).  
2. Log into [youtube.com](https://youtube.com).  
3. Export cookies and save them as `cookies.txt` in this repo’s folder.  
4. Refresh this file whenever downloads fail due to expired cookies.

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

3. New MP3s will appear inside `downloads/`.

---

## Script Details

- **Script path config:**
  - `OUTDIR` → where MP3s are saved  
  - `COOKIES` → path to cookies file  
  - `ARCHIVE` → list of already downloaded video IDs  
- **yt-dlp options used:**
  - `--extract-audio --audio-format mp3 --audio-quality 0` → highest quality MP3  
  - `--embed-thumbnail --add-metadata` → embed cover art + tags  
  - `--download-archive archive.txt` → skip duplicates  
  - `--ignore-errors` → continue if some videos are private/deleted  

---

## Roadmap / Ideas
- [ ] Add cron job to auto-sync daily  
- [ ] Support other playlists, not just "Liked videos"  
- [ ] Optional FLAC/OGG export  

---

## ⚠️ Disclaimer
Downloading YouTube content may violate YouTube’s Terms of Service. This script is provided for **personal use only**. Please respect copyright and artists’ work.
