# AGENTS.md: Project Signpost

This file provides a brief overview of all files in this project, which is a podcast download container.

## Dockerfile

**Purpose:** Container image definition for the podcast downloader application.

**Summary:**
- Uses Debian slim base image with Python 3.9
- Installs dependencies: curl, jq, bash, ffmpeg, ca-certificates
- Downloads and installs `podcast-dl` v12.1.0 binary
- Copies all shell scripts into the container
- Sets up entry point script to launch the application

---

## Scripts

### entrypoint.sh
**Purpose:** Main container entry point that orchestrates the download workflow.

**Summary:**
- Accepts command-line arguments: `--debug` (optional), `<URL>` (required)
- Supports multiple modes:
  - List all episodes in RSS feed
  - Download a specific episode by number
  - Download episodes in a range (e.g., 1-5)
  - Download multiple episodes (comma-separated)
- Calls appropriate shell scripts based on arguments
- Handles debug mode for verbose output
- Displays usage information if called without arguments

---

### range.sh
**Purpose:** Expand episode number ranges into comma-separated lists.

**Summary:**
- Accepts input in formats: `1,3,5`, `1-5`, `1-3,5-7`
- Expands ranges (e.g., `1-5` becomes `1,2,3,4,5`)
- Validates that all inputs are integers
- Validates that range start ≤ range end
- Outputs expanded comma-separated list

---

### download.sh
**Purpose:** Download a specific episode from the RSS feed.

**Summary:**
- Requires single argument: `<episode-number>`
- Reads episode title from the RSS file using list.sh
- Validates episode exists in RSS feed
- Escapes special characters for podcast-dl regex
- Downloads episode using podcast-dl with `--episode-regex` option
- Copies downloaded file to `/download.mp3` (handling various audio formats)
- Reports success/failure status

---

### rss.sh
**Purpose:** Fetch and manage the RSS feed file.

**Summary:**
- Accepts URL as argument
- Checks if `rss` file exists locally
- Downloads RSS feed using curl if not present
- Stores feed in `/rss` file for subsequent operations

---

### list.sh
**Purpose:** List all episodes in the RSS feed with their numbers and titles.

**Summary:**
- Uses podcast-dl's `--list json` option to parse RSS file
- Outputs human-readable format: `episodeNum-title`
- Processes JSON output through jq for parsing
- Cleans titles (replaces special chars with underscores, removes leading/trailing underscores)
- Converts to lowercase for consistency

---

## See [README.md](README.md) for usage examples and documentation.

## Technical Notes

- All scripts are written in bash
- Debug mode (`--debug`) enables verbose output and X tracing
- Episode numbers are 1-based integers
- Downloads are stored in `/tmp` then copied to container root
- Uses `podcast-dl` v12.1.0 as the core podcast downloader
- Handles multiple audio formats (mp3, m4a, mp4)
