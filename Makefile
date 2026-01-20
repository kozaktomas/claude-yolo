.PHONY: build run test clean

IMAGE_NAME := claude-yolo

# Auto-detect container engine: prefer podman, fallback to docker
# Override with: make ENGINE=docker build
ENGINE := $(shell command -v podman >/dev/null 2>&1 && echo podman || echo docker)

build:
	$(ENGINE) build -t $(IMAGE_NAME) .
	@$(ENGINE) images $(IMAGE_NAME) --format "Size: {{.Size}}"

run:
	$(ENGINE) run -it --rm -v $(PWD):/workspace $(IMAGE_NAME)

test:
	$(ENGINE) run --rm $(IMAGE_NAME) -c test-installs

clean:
	$(ENGINE) rmi $(IMAGE_NAME)
