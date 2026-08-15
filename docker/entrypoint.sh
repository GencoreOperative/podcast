#!/bin/bash

# Default values
DEBUG=""
RSS_URL=""
EPI_ARGS=""

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
    EPI_ARGS="$1"
    shift
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
if [ -z "$EPI_ARGS" ]; then
    bash $DEBUG list.sh
    exit 0
fi

# ------------
# Episode Mode
# ------------
# Otherwise, we are processing a specific set of episodes.

# Expand episode arguments (ranges and comma-separated lists)
EPI_LIST=$(bash $DEBUG range.sh "$EPI_ARGS")

if [ -z "$EPI_LIST" ]; then
    echo "Error: No valid episode numbers provided"
    exit 1
fi

# Download each episode to a temporary file
DOWNLOAD_DIR="/tmp/podcast_downloads"
mkdir -p "$DOWNLOAD_DIR"

echo "Downloading episodes: $EPI_LIST"
FAILED=0

IFS=',' read -ra EPI_NUMS <<< "$EPI_LIST"
for EPI_NUM in "${EPI_NUMS[@]}"; do
    echo "Downloading episode $EPI_NUM..."
    bash $DEBUG /download.sh "$EPI_NUM" > "$DOWNLOAD_DIR/ep${EPI_NUM}_$(date +%s).tmp" 2>&1
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to download episode $EPI_NUM"
        rm -f "$DOWNLOAD_DIR/ep${EPI_NUM}_$(date +%s).tmp"
        FAILED=$((FAILED + 1))
    else
        echo "Successfully downloaded episode $EPI_NUM"
        # Rename to episode number
        mv "$DOWNLOAD_DIR/ep${EPI_NUM}_$(date +%s).tmp" "$DOWNLOAD_DIR/ep${EPI_NUM}.tmp"
    fi
done

# Create tar archive of all downloaded files
TAR_FILE="$DOWNLOAD_DIR/episodes.tar.gz"
cd "$DOWNLOAD_DIR"
tar -czf "$TAR_FILE" ep*.tmp 2>/dev/null || true

# Output tar archive to stdout
cat "$TAR_FILE"

# Cleanup
rm -rf "$DOWNLOAD_DIR"

if [ $FAILED -gt 0 ]; then
    echo ""
    echo "Completed $(( ${#EPI_NUMS[@]} - FAILED )) of ${#EPI_NUMS[@]} episodes"
fi
