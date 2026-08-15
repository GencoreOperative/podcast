# Plan: Podcast Docker Refactoring

## Overview
This plan documents the refactoring of the podcast Docker project to improve usability and simplify the workflow.

## Changes

### 1. Update entrypoint.sh: URL as Flagged Argument
- Change the URL argument from a positional argument to a flagged argument `--rss`
- Update usage documentation to reflect the new syntax
- Modify argument parsing logic to handle `--rss` flag followed by the RSS URL

### 2. Add STDIN Mode to entrypoint.sh
- Add a new mode where RSS XML can be piped from STDIN
- When no `--rss` flag is provided, read RSS XML from STDIN instead
- Update usage documentation to document the STDIN mode
- Handle both modes: `--rss <URL>` (default) and implicit STDIN mode

### 3. Pipe Downloaded MP3 Files as a Tar Archive to STDOUT
- Modify `entrypoint.sh` to collect all downloaded MP3 files
- Compress them into a single tar archive and pipe to STDOUT
- Use this in combination with `podcast` script (see step 4)

### 4. Update `podcast` script to consume the tar archive
- Remove volume mount requirement
- Expect tar archive from stdin
- Extract files to current working directory
- Provide clear error handling for failed extraction
