#!/bin/bash

# Check if the script received the correct arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <episode-number>"
    exit 1
fi

EPISODE_NUM="$1"
RSS_FILE="rss"

# Check if the RSS file exists
if [ ! -f "$RSS_FILE" ]; then
    echo "Error: RSS file '$RSS_FILE' not found."
    exit 1
fi

# Get the episode title for the given episode number
EPISODE_TITLE=$(bash /list.sh | grep ^"$EPISODE_NUM" | cut -d '-' -f 2)

# Check if an episode was found
if [ -z "$EPISODE_TITLE" ]; then
    echo "Error: Episode with number $EPISODE_NUM not found in RSS file."
    exit 1
fi

# Escape special characters in the title for regex
ESCAPED_TITLE=$(echo "$EPISODE_TITLE" | sed 's/[\/&?()]/\\&/g')

# Use the episode-regex option to download the episode
podcast-dl --file "$RSS_FILE" \
    --episode-regex "$ESCAPED_TITLE" \
    --out-dir "/tmp" \
    --episode-template "download" \
    --override

# Check if the download succeeded
if [ $? -ne 0 ]; then
    echo "Error: Failed to download episode '$EPISODE_TITLE'."
    exit 1
fi

echo "Successfully downloaded episode '$EPISODE_TITLE'."
if [ -f /tmp/download.mp3 ]; then
    cp /tmp/download.mp3 download.mp3
elif [ -f /tmp/download.m4a ]; then
    cp /tmp/download.m4a download.mp3
elif [ -f /tmp/download.mp4 ]; then
    ffmpeg -y -i /tmp/download.mp4 download.mp3
else
    echo "Did not recognise the downloaded file type."
    ls -las /tmp
fi