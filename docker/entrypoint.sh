#!/bin/bash

# Default values
DEBUG=""
RSS_URL=""

# Parse arguments using getopts
while getopts ":dr:" opt; do
    case $opt in
        d)
            DEBUG="-x"
            set -x
            ;;
        r)
            RSS_URL="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Check if we have remaining arguments (episode args)
if [ $# -gt 0 ]; then
    EPI_START="$1"
    EPI_END="${2:-}"
fi

# --------------
# RSS Processing
# --------------
# The user is either providing the RSS on STDIN or via argument.
# In either case, we extract it to the current folder in a file called rss.

RSS_FILE=rss
if [ -z "$RSS_URL" ]; then
    # STDIN Mode
    cat > $RSS_FILE
else
    curl -f -s -o $RSS_FILEE -L "$1"
    if [[ $? -ne 0 ]]; then
        echo "Failed to read RSS Feed: $RSS_URL"
        exit 1
    fi
fi

# ---------
# List Mode
# ---------
# Next, if we have not episodes requested, we are in list mode

# If no episode arguments provided, list episodes
if [ -z "$EPI_START" ]; then
    bash $DEBUG list.sh
    exit 0
fi

# ------------
# Episode Mode
# ------------
# Otherwise, we are processing a specific set of episodes.

# Expand episode arguments (ranges and comma-separated lists)
EPI_ARGS=("$EPI_START")

if [[ -n "$EPI_END" ]]; then
    EPI_ARGS+=("$EPI_END")
fi

EPI_LIST=$(bash $DEBUG range.sh "${EPI_ARGS[@]}")

if [ -z "$EPI_LIST" ]; then
    echo "Error: No valid episode numbers provided"
    exit 1
fi

# Download each episode to a temporary file
DOWNLOAD_DIR="/tmp/podcast_downloads"
mkdir -p "$DOWNLOAD_DIR"

FAILED=0

IFS=',' read -ra EPI_NUMS <<< "$EPI_LIST"
for EPI_NUM in "${EPI_NUMS[@]}"; do
    bash $DEBUG download.sh "$EPI_NUM"
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to download episode $EPI_NUM"
        exit 1
    fi
done

# Create tar archive of all downloaded files
tar -cvf - *.mp3 2>/dev/null