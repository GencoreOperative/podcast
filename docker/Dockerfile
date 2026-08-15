# Use a Python 3.9 base image
FROM debian:stable-20241111-slim

# Install dependencies for curl and other tools to handle the binary
RUN apt-get update && \
    apt-get install -y \
    curl \
    jq \
    bash \
    ffmpeg \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download and install the podcast-dl binary
RUN curl -Lf https://github.com/lightpohl/podcast-dl/releases/download/v12.1.0/podcast-dl-12.1.0-linux-x64 -o /usr/local/bin/podcast-dl && \
    chmod +x /usr/local/bin/podcast-dl

# Set the working directory inside the container
WORKDIR /podcast

ADD *.sh /podcast

ENTRYPOINT ["/bin/bash", "/podcast/entrypoint.sh" ]