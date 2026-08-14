#!/bin/bash

# List the episodes in the RSS file.
# RSS files can contain Many episodes. When posdcast-dl processes this
# it will minifiy it all down to a single line.

# Confusingly, jq is unable to handle parsing such a long ling of text 
# (65K limit), so we first need to use JQ to make the JSON human readable
# first. Then we can perform the processing we need.

TMP_JSON=/tmp/json
/usr/local/bin/podcast-dl --file rss --list json > $TMP_JSON

# Parse the JSON and extract episode numbers and cleaned titles
#cat $TMP_JSON | jq . | jq -r '.[] | "\(.episodeNum)-\(.title))"' | sed -e 's/[^a-zA-Z0-9]/_/g' -e 's/_\+/_/g' -e 's/^_//g' -e 's/_$//g' | tr '[:upper:]' '[:lower:]'
cat $TMP_JSON | jq . | jq -r '.[] | "\(.episodeNum)-\(.title)"'