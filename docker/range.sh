#!/bin/bash

# Expand episode numbers (single or range) into a comma-separated list
# Usage: ./expand-range.sh "1,3,5" or ./expand-range.sh "1-5" or ./expand-range.sh "1-3,5-7"

set -e

INPUT="$1"

if [ -z "$INPUT" ]; then
    echo "Error: No input provided"
    exit 1
fi

# Split by comma and expand each part
RESULT=""
IFS=',' read -ra PARTS <<< "$INPUT"

for PART in "${PARTS[@]}"; do
    # Trim whitespace
    PART=$(echo "$PART" | tr -d ' ')
    
    # Check if it's a range (contains -)
    if [[ "$PART" == *"-"* ]]; then
        START=$(echo "$PART" | cut -d'-' -f1)
        END=$(echo "$PART" | cut -d'-' -f2)
        
        # Validate numbers
        if ! [[ "$START" =~ ^[0-9]+$ ]] || ! [[ "$END" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid range '$PART' - both numbers must be integers"
            exit 1
        fi
        
        # Check for invalid range direction
        if [ "$START" -gt "$END" ]; then
            echo "Error: Invalid range '$PART' - start must be less than or equal to end"
            exit 1
        fi
        
        # Expand using seq
        SEQUENCE=$(seq "$START" "$END" | tr '\n' ',' | sed 's/,$//')
    else
        # Single number
        if ! [[ "$PART" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid number '$PART'"
            exit 1
        fi
        SEQUENCE="$PART"
    fi
    
    if [ -z "$RESULT" ]; then
        RESULT="$SEQUENCE"
    else
        RESULT="$RESULT,$SEQUENCE"
    fi
done

echo "$RESULT"
