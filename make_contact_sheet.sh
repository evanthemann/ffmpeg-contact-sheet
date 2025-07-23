#!/bin/bash

clear
echo "🎞️  Welcome to the Contact Sheet Maker with ffmpeg!"
echo "This script will create a tiled image of thumbnails from your video."
sleep 1

read -rp $'\n📂 Drag and drop your video file here, then press Enter: ' RAW_INPUT
sleep 1

# Remove surrounding quotes (if any) and handle escaped spaces
VIDEO_PATH=$(eval echo "$RAW_INPUT")

if [ ! -f "$VIDEO_PATH" ]; then
  echo -e "\n❌ Error: File not found at:"
  echo "$VIDEO_PATH"
  exit 1
fi

echo -e "\n✅ Received file: $VIDEO_PATH"
sleep 1

VIDEO_DIR=$(dirname "$VIDEO_PATH")
VIDEO_BASENAME=$(basename "$VIDEO_PATH")
OUTPUT_FILENAME="${VIDEO_BASENAME%.*}.jpg"
OUTPUT_PATH="${VIDEO_DIR}/${OUTPUT_FILENAME}"

echo -e "\n📁 The output image will be saved to:"
echo "$VIDEO_DIR"
sleep 1

echo -e "\n🖼️  The contact sheet will be named:"
echo "$OUTPUT_FILENAME"
sleep 1

# echo -e "\n📋 Default ffmpeg settings:"
# echo "  fps=1/300     → grabs 1 frame every 5 minutes"
# echo "  scale=320:-1  → resizes each frame to 320px wide, keeping aspect ratio"
# echo "  tile=5x5      → arranges frames in a 5 by 5 grid (25 images total)"

echo -e "\n📋 Default ffmpeg settings:"
echo "  fps (variable) → Calculates the frame rate needed to divide the video evenly into 25 pictures"
echo "  scale=320:-1   → resizes each frame to 320px wide, keeping aspect ratio"
echo "  tile=5x5       → arranges frames in a 5 by 5 grid (25 images total)"

sleep 1

read -rp $'\nPress y to continue, or q to quit: ' CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "👋 Exiting!"
  exit 0
fi

echo -e "\n🚀 Running ffmpeg..."
sleep 1

# Get duration in seconds using ffprobe
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO_PATH")

# Compute frames per second to get 25 thumbnails evenly spaced
FPS=$(awk "BEGIN {print 25 / $DURATION}")

echo "Duration:"
echo "$DURATION"

# ffmpeg -i "$VIDEO_PATH" -vf "fps=1/300,scale=320:-1,tile=5x5" -frames:v 1 "$OUTPUT_PATH"

ffmpeg -hide_banner -loglevel error -i "$VIDEO_PATH" -vf "fps=$FPS,scale=320:-1,tile=5x5" -frames:v 1 "$OUTPUT_PATH"

echo -e "\n✅ Done! Contact sheet saved to:"
echo "$OUTPUT_PATH"

