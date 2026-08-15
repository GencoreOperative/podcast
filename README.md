# podcast-dl Container

A Docker container for downloading podcast episodes from RSS feeds using [podcast-dl](https://github.com/lightpohl/podcast-dl).

## Quick Start

```bash
# Pull the latest image
docker pull robert-wapshott/podcast-dl

# Run the container
docker run -v $(pwd):/podcast -it podcast-dl --help
```

## Usage

```bash
# List all episodes in RSS feed
docker run podcast-dl <RSS_URL>

# Download a specific episode
docker run podcast-dl <RSS_URL> <episode-number>

# Download episodes in a range (e.g., episodes 1-5)
docker run podcast-dl <RSS_URL> <episode1>-<episode2>

# Download multiple episodes (comma-separated)
docker run podcast-dl <RSS_URL> <ep1,ep2,ep3>

# Download with verbose/debug output
docker run -it podcast-dl --debug <RSS_URL> <episode-number>
```

## Output

Downloaded episodes are saved as `download.mp3` in the container's working directory.

## Examples

```bash
# List episodes from a podcast
docker run podcast-dl https://feeds.megaphone.fm/podcast-url

# Download episodes 1-10
docker run podcast-dl https://feeds.megaphone.fm/podcast-url 1-10

# Download specific episodes
docker run podcast-dl https://feeds.megaphone.fm/podcast-url 5,10,15
```

## Development

See [AGENTS.md](AGENTS.md) for detailed information about each component file.
