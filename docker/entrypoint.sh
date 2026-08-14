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
    exit 1
fi

# Assign the first argument to a variable
URL="$1"

bash $DEBUG /rss.sh "$URL"

if [[ $? -ne 0 ]]; then
    echo "Failed to read RSS Feed: $URL"
    exit 1
fi

# Validate the second argument, if provided, is a number
if [ "$#" -ge 2 ]; then
    if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: The second argument must be a number"
        exit 1
    fi
    bash $DEBUG /download.sh "$2"
else
    bash $DEBUG /list.sh
fi
