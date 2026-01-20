.PHONY: build run test clean

IMAGE_NAME := claude-yolo

build:
	podman build -t $(IMAGE_NAME) .
	@podman images $(IMAGE_NAME) --format "Size: {{.Size}}"

run:
	podman run -it --rm -v $(PWD):/workspace $(IMAGE_NAME)

test:
	podman run --rm $(IMAGE_NAME) -c test-installs

clean:
	podman rmi $(IMAGE_NAME)
