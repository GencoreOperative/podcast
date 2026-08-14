#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage:"
    echo "  $0 <URL>                    - List all episodes in the RSS Feed"
    echo "  $0 <URL> <episode-number>   - Download a specific episode by number"
    exit 1
fi

# Validate the first argument is a URL
URL_REGEX="^(https?://)"
if [[ ! "$1" =~ $URL_REGEX ]]; then
    echo "Error: The first argument must be a valid URL (starting with http:// or https://)"
    exit 1
fi

# Assign the first argument to a variable
URL="$1"
bash /rss.sh "$URL"

# Validate the second argument, if provided, is a number
if [ "$#" -ge 2 ]; then
    if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: The second argument must be a number"
        exit 1
    fi
    bash /download.sh "$2"
else
    bash /list.sh
fi