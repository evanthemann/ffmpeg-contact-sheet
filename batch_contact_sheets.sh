#!/bin/bash

echo "🎞️  Welcome to the Batch Contact Sheet Maker!"
echo "This script will create a tiled thumbnail image for every .mp4 video it finds in a folder (and subfolders)."
sleep 1

read -rp $'\n📁 Drag and drop the folder to search inside, then press Enter: ' RAW_DIR
sleep 1

# Normalize the folder path
SEARCH_DIR=$(eval echo "$RAW_DIR")

# Check if it's a valid directory
if [ ! -d "$SEARCH_DIR" ]; then
  echo -e "\n❌ Error: That is not a valid directory."
  exit 1
fi

# Initialize array
VIDEO_FILES=()

echo -e "\n🔍 Searching for .mp4 files inside:"
echo "$SEARCH_DIR"
sleep 1

# Use find in a loop
while IFS= read -r -d '' file; do
  VIDEO_FILES+=("$file")
done < <(find "$SEARCH_DIR" -type f \( -iname "*.mp4" \) -print0)

# Check if any files found
if [ ${#VIDEO_FILES[@]} -eq 0 ]; then
  echo -e "\n⚠️  No .mp4 files found in this directory."
  exit 0
fi

echo -e "\n📄 Found the following .mp4 files:"
for FILE in "${VIDEO_FILES[@]}"; do
  echo "$FILE"
done

NUM_FOUND=${#VIDEO_FILES[@]}
echo -e "\n✅ Found $NUM_FOUND video file(s)."
echo "Note: This only includes files with the .mp4 extension (case-insensitive)."

read -rp $'\nPress y to continue, or q to quit: ' CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "👋 Exiting!"
  exit 0
fi

echo -e "\n🚀 Generating contact sheets..."

COUNT_DONE=0

for VIDEO_PATH in "${VIDEO_FILES[@]}"; do
  VIDEO_DIR=$(dirname "$VIDEO_PATH")
  VIDEO_BASENAME=$(basename "$VIDEO_PATH")
  OUTPUT_FILENAME="${VIDEO_BASENAME%.*}_tile.jpg"
  OUTPUT_PATH="${VIDEO_DIR}/${OUTPUT_FILENAME}"

  if [ -f "$OUTPUT_PATH" ]; then
    echo "⚠️  Skipping: $OUTPUT_FILENAME already exists."
    continue
  fi

  echo -e "\n📷 Processing:"
  echo "$VIDEO_BASENAME"

  # Get duration in seconds using ffprobe
  DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO_PATH")

  # Compute frames per second to get 25 thumbnails evenly spaced
  FPS=$(awk "BEGIN {print 25 / $DURATION}")

  echo "Duration:"
  echo "$DURATION"

  # constant calculation
  
  # ffmpeg -hide_banner -loglevel error -i "$VIDEO_PATH" \
  #   -vf "fps=1/300,scale=320:-1,tile=5x5" -frames:v 1 "$OUTPUT_PATH"

  # dynamic calcuation
  ffmpeg -hide_banner -loglevel error -i "$VIDEO_PATH" \
    -vf "fps=$FPS,scale=320:-1,tile=5x5" -frames:v 1 "$OUTPUT_PATH"

  if [ $? -eq 0 ]; then
    echo "✅ Created: $OUTPUT_FILENAME"
    ((COUNT_DONE++))
  else
    echo "❌ Failed to process: $VIDEO_PATH"
  fi
done

echo -e "\n🎉 Finished! Successfully created $COUNT_DONE contact sheet(s)."

