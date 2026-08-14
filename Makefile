# Name of the Docker image
IMAGE_NAME = podcast-dl:latest

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) docker

# Remove the Docker image
clean:
	docker rmi $(IMAGE_NAME)

# Rebuild the Docker image
rebuild: clean builds