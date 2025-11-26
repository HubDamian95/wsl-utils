#!/usr/bin/env bash
set -euo pipefail

#I'm using this to convert .flac to .m4a

#usage:
#To be used in WSL, needs ffmpeg to be installed on WSL as well as dos2unix
#Have FLAC files in folders in your music folder.
#Place this file into /mnt/c/Users/$WINUSER/Music
#dos2unix convert-flac-to-m4a.sh
#chmod 755 ./convert-flac-to-m4a.sh
#./convert-flac-to-m4a.sh
WINUSER="$(whoami)"

SRC="/mnt/c/Users/$WINUSER/Music"
DST="/mnt/c/Users/$WINUSER/Music/m4a"

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
