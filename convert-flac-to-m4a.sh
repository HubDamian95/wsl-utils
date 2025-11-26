#!/usr/bin/env bash
set -euo pipefail

#To be used in WSL, needs ffmpeg to be installed on WSL as well as dos2unix
#dos2unix convert-flac-to-m4a.sh

SRC="/mnt/c/Users/hubd/Music"
DST="/mnt/c/Users/hubd/Music/m4a"

find "$SRC" -type f -name "*.flac" -print0 |
while IFS= read -r -d '' f; do
    rel="${f#$SRC/}"
    base="${rel%.flac}"
    out="$DST/$base.m4a"

    # Skip if already converted
    [[ -f "$out" ]] && {
        echo "Skipping existing: $out"
        continue
    }

    mkdir -p "$(dirname "$out")"

    ffmpeg -nostdin -hide_banner -loglevel error \
        -stats \
        -i "$f" \
        -map_metadata 0 \
        -c:a alac \
        "$out"
done
