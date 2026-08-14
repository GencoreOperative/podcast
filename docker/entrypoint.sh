#!/bin/bash

# Check if --debug flag is passed
DEBUG=""
if [[ "$1" == "--debug" ]]; then
    DEBUG="-x"
    shift
fi

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage:"
    echo "  $0 [--debug] <URL>                    - List all episodes in the RSS Feed"
    echo "  $0 [--debug] <URL> <episode-number>   - Download a specific episode by number"
    echo "  $0 [--debug] <URL> <range>            - Download episodes in a range (e.g., 1-5)"
    echo "  $0 [--debug] <URL> <episode1,episode2,...> - Download multiple episodes"
    exit 1
fi

# Assign the first argument to a variable
URL="$1"

bash $DEBUG /rss.sh "$URL"

if [[ $? -ne 0 ]]; then
    echo "Failed to read RSS Feed: $URL"
    exit 1
fi

# If no episode number provided, list episodes
if [ "$#" -eq 1 ]; then
    bash $DEBUG /list.sh
    exit 0
fi

# Get episode numbers from second argument
EPI_STR="$2"

# Expand ranges (e.g., 1-5 -> 1,2,3,4,5)
EPI_LIST=$(bash $DEBUG /range.sh "$EPI_STR")

if [ -z "$EPI_LIST" ]; then
    echo "Error: No valid episode numbers provided"
    exit 1
fi

# Download each episode
echo "Downloading episodes: $EPI_LIST"
FAILED=0

IFS=',' read -ra EPI_NUMS <<< "$EPI_LIST"
for EPI_NUM in "${EPI_NUMS[@]}"; do
    echo "Downloading episode $EPI_NUM..."
    bash $DEBUG /download.sh "$EPI_NUM"
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to download episode $EPI_NUM"
        FAILED=$((FAILED + 1))
    else
        echo "Successfully downloaded episode $EPI_NUM"
    fi
done

if [ $FAILED -gt 0 ]; then
    echo ""
    echo "Completed $(( ${#EPI_NUMS[@]} - FAILED )) of ${#EPI_NUMS[@]} episodes"
fi
