# ffmpeg Contact Sheet

Generate tiled thumbnail contact sheets from video files using ffmpeg. Each contact sheet is a 5x5 grid of 25 evenly spaced frames, saved as a JPEG image alongside the source video.

## Scripts

### make_contact_sheet.sh

Creates a contact sheet from a single video file. The script prompts you to drag and drop a video, calculates 25 evenly spaced frames based on the video duration, and outputs a tiled image named `<video>_tile.jpg` in the same directory as the source file.

```
bash make_contact_sheet.sh
```

### batch_contact_sheets.sh

Creates contact sheets for all `.mp4` files found recursively within a given folder. The script prompts you to drag and drop a directory, finds every `.mp4` file inside it (including subfolders), and generates a contact sheet for each one. Videos that already have a corresponding `_tile.jpg` file are skipped.

```
bash batch_contact_sheets.sh
```

## Requirements

- ffmpeg
- ffprobe (included with ffmpeg)
- bash
