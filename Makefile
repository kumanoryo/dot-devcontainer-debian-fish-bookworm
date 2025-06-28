DOCKERHUB_REPONAME=ghcr.io/bearfield
CONTAINER_NAME=debian-fish
CONTAINER_TAG=test.bookworm

# Build arguments with default values
USER_NAME ?= devuser
USER_ID ?= 1000
GROUP_ID ?= $(USER_ID)

# Build args for docker buildx
BUILD_ARGS = --build-arg USER_NAME=$(USER_NAME) --build-arg USER_ID=$(USER_ID) --build-arg GROUP_ID=$(GROUP_ID)

MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
WORK_DIR=$(MAKEFILE_DIR)

.PHONY:test.build.arm64
test.build.arm64:
	cd $(WORK_DIR)
	docker buildx build $(BUILD_ARGS) --tag=$(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG).arm64 ./docker --platform linux/arm64

.PHONY:test.build.amd64
test.build.amd64:
	cd $(WORK_DIR)
	docker buildx build $(BUILD_ARGS) --tag=$(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG).amd64 ./docker --platform linux/amd64

.PHONY:test.rmi.arm64
test.rmi.arm64:
	docker rmi $(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG).arm64

.PHONY:test.rmi.amd64
test.rmi.amd64:
	docker rmi $(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG).amd64

.PHONY:test.arm64
test.arm64: test.build.arm64 test.rmi.arm64

.PHONY:test.amd64
test.amd64: test.build.amd64 test.rmi.amd64

.PHONY:test
test: test.arm64 test.amd64