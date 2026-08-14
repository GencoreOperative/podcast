#!/bin/bash

# Responsible for locating the provided RSS and outputting the contents.
# If the RSS file is not present locally, it will be downloaded from
# the provided URL.

FILE="rss"

# Check if the file exists
if [ ! -s "$FILE" ]; then
    # Download the RSS file from the provided URL
    curl -f -s -o "$FILE" -L "$1"
fi
