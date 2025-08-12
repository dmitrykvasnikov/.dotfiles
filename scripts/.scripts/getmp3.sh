#!/bin/bash
for file in *.mp4; do
    ffmpeg -i "$file" -q:a 0 -map a "${file%.mp4}.mp3"
done
