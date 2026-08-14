#!/bin/bash

# Argument validation:
# The first argument must be a URL
# The second argument is optional, but if provided, must be a number.

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <URL> [number]"
    echo "Example: $0 https://example.com/rss 5"
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