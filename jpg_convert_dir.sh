#!/bin/bash

find "$1" -type f -and \( -iname "*.webp" \) -print0 | while IFS= read -r -d '' f; do
  FPATH=${f%%.*}
  FEXT=${f##*.}
  PNGFILE="$FPATH".png
  JPGFILE="$FPATH".jpg
  JPGFILE_ORIGINAL="$FPATH".jpg_original

  # Convert to png
  # This auto-rotates the file correctly, but doesn't copy any metadata
  dwebp "$f" -mt -quiet -o "$PNGFILE"

  # Convert to jpg
  magick -quiet "$PNGFILE" "$JPGFILE"

  # Copy exif data
  exiftool -quiet -tagsfromfile "$f" -all:all "$JPGFILE"

  # Clear the rotation field
  jhead -q -norot "$JPGFILE"

  # Remove the files
  rm "$f"
  rm "$PNGFILE"
  rm "$JPGFILE_ORIGINAL"

  echo "Done converting $JPGFILE"
done
