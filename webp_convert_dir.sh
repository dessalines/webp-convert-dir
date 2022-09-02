#!/bin/bash

find $1 -type f -and \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | while IFS= read -r -d '' f; do
  FPATH=${f%%.*}
  FEXT=${f##*.}
  WEBPFILE="$FPATH".webp
  cwebp "$f" -mt -metadata all -q 90 -quiet -o "$WEBPFILE" || continue
  rm "$f"
  echo "Done converting $WEBPFILE"
done
